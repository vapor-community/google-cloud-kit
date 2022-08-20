//
//  ServiceAccountCredentialsProvider.swift
//  
//
//  Created by Andrew Edwards on 2/19/22.
//

import Foundation
import AsyncHTTPClient
import NIO
import JWTKit
import NIOFoundationCompat

/// https://google.aip.dev/auth/4112
public actor ServiceAccountCredentialsProvider: AccessTokenProvider {
    static let audience = "https://oauth2.googleapis.com/token"
    
    let client: HTTPClient
    let credentials: ServiceAccountCredentials
    var accessToken: AccessToken?
    var tokenExpiration: Date?
    let decoder = JSONDecoder()
    let scope: [GoogleCloudAPIScope]
    
    public init(client: HTTPClient,
                credentials: ServiceAccountCredentials,
                scope: [GoogleCloudAPIScope]) {
        self.client = client
        self.credentials = credentials
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.scope = scope
    }
    
    public func getAccessToken() async throws -> String {
        if let existingToken = accessToken,
           let expiration = tokenExpiration {
            if expiration >= Date() {
                return existingToken.accessToken
            } else {
                return try await refresh()
            }
        } else {
            return try await refresh()
        }
    }
    
    private func buildRequest() throws -> HTTPClientRequest {
        let assertion = try generateAssertion()
        var request = HTTPClientRequest(url: credentials.tokenUri)
        request.method = .POST
        request.headers = ["Content-Type": "application/x-www-form-urlencoded"]
        request.body = .bytes(ByteBuffer(string: "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=\(assertion)"))
        
        return request
    }
    
    @discardableResult
    private func refresh() async throws -> String {        
        // if we have a scope provided explicitly, use oath.
        // Otherwise we self sign a JWT if no explicit scope was provided.        
        if scope.isEmpty {
        // https://google.aip.dev/auth/4111
            let expiration = Date().addingTimeInterval(3600).timeIntervalSince1970
            let payload = ServiceAccountCredentialsSelfSignedJWTPayload(iss: .init(value: credentials.clientEmail),
                                                                        exp: .init(value: Date().addingTimeInterval(3600)),
                                                                        iat: .init(value: Date()),
                                                                        sub: .init(value: credentials.clientEmail),
                                                                        scope: scope.map(\.value).joined(separator: " "))
            
            let privateKey = try RSAKey.private(pem: credentials.privateKey.data(using: .utf8, allowLossyConversion: true) ?? Data())
            
            let token = try JWTSigner.rs256(key: privateKey).sign(payload, kid: .init(string: credentials.privateKeyId))
            
            accessToken = AccessToken(accessToken: token, tokenType: "", expiresIn: Int(expiration))
            
            // scrape off 5 minutes so we're not runnung up against time boundaries.
            tokenExpiration = Date().addingTimeInterval(TimeInterval(Int(expiration) - 300))
            
            return token
        } else {
            let response = try await client.execute(buildRequest(), timeout: .seconds(10))
            let body = Data(buffer: try await response.body.collect(upTo: 1024 * 1024)) // 1mb
            guard response.status == .ok else {
                throw try decoder.decode(GoogleCloudOAuthError.self, from: body)
            }
            
            let token = try decoder.decode(AccessToken.self, from: body)
            accessToken = token
            // scrape off 5 minutes so we're not runnung up against time boundaries.
            tokenExpiration = Date().addingTimeInterval(TimeInterval(token.expiresIn - 300))
            return token.accessToken
        }
    }
    
    private func generateAssertion() throws -> String {
        let payload = ServiceAccountCredentialsJWTPayload(iss: .init(value: credentials.clientEmail),
                                                          aud: .init(value: Self.audience),
                                                          exp: .init(value: Date().addingTimeInterval(3600)),
                                                          iat: .init(value: Date()),
                                                          sub: .init(value: credentials.clientEmail),
                                                          scope: scope.map(\.value).joined(separator: " "))
        
        let privateKey = try RSAKey.private(pem: credentials.privateKey.data(using: .utf8, allowLossyConversion: true) ?? Data())
        
        return try JWTSigner.rs256(key: privateKey).sign(payload, kid: .init(string: credentials.privateKeyId))
    }
}

/// Structure of a service account
public struct ServiceAccountCredentials: Codable {
    public let type: String
    public let projectId: String
    public let privateKeyId: String
    public let privateKey: String
    public let clientEmail: String
    public let clientId: String
    public let authUri: String
    public let tokenUri: String
    public let authProviderX509CertUrl: String
    public let clientX509CertUrl: String
}

/// The payload for requesting an OAuth token to make API calls to Google APIs.
struct ServiceAccountCredentialsJWTPayload: JWTPayload {
    /// The email address of the service account.
    var iss: IssuerClaim
    /// A descriptor of the intended target of the assertion. When making an access token request this value is always https://oauth2.googleapis.com/token
    var aud: AudienceClaim
    /// The expiration time of the assertion, specified as seconds since 00:00:00 UTC, January 1, 1970. This value has a maximum of 1 hour after the issued time.
    var exp: ExpirationClaim
    /// The time the assertion was issued, specified as seconds since 00:00:00 UTC, January 1, 1970.
    var iat: IssuedAtClaim
    /// Using to nominate the account you want access to on the domain from a service account
    var sub: SubjectClaim
    /// The scope of access being requested.
    var scope: String
    
    public func verify(using signer: JWTSigner) throws {
        try exp.verifyNotExpired()
    }
}

struct ServiceAccountCredentialsSelfSignedJWTPayload: JWTPayload {
    /// The email address of the service account.
    var iss: IssuerClaim
    /// The expiration time of the assertion, specified as seconds since 00:00:00 UTC, January 1, 1970. This value has a maximum of 1 hour after the issued time.
    var exp: ExpirationClaim
    /// The time the assertion was issued, specified as seconds since 00:00:00 UTC, January 1, 1970.
    var iat: IssuedAtClaim
    /// Using to nominate the account you want access to on the domain from a service account
    var sub: SubjectClaim
    /// The scope of access being requested.
    var scope: String
    
    public func verify(using signer: JWTSigner) throws {
        try exp.verifyNotExpired()
    }
}
