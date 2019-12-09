//
//  OAuthServiceAccount.swift
//  GoogleCloudProvider
//
//  Created by Andrew Edwards on 4/15/18.
//

import JWTKit
import NIO
import NIOHTTP1
import AsyncHTTPClient
import Foundation

public class OAuthServiceAccount: OAuthRefreshable {
    public let httpClient: HTTPClient
    public let credentials: GoogleServiceAccountCredentials
    public let scope: String

    private let decoder = JSONDecoder()
    
    init(credentials: GoogleServiceAccountCredentials, scopes: [GoogleCloudAPIScope], httpClient: HTTPClient) {
        self.credentials = credentials
        self.scope = scopes.map { $0.value }.joined(separator: " ")
        self.httpClient = httpClient
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    // Google Documentation for this approach: https://developers.google.com/identity/protocols/OAuth2ServiceAccount
    public func refresh() -> EventLoopFuture<OAuthAccessToken> {
        do {
            let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
            let token = try generateJWT()
            let body: HTTPClient.Body = .string("grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=\(token)"
                                        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            let request = try HTTPClient.Request(url: GoogleOAuthTokenUrl, method: .POST, headers: headers, body: body)
            
            return httpClient.execute(request: request).flatMap { response in
                
                guard var byteBuffer = response.body,
                let responseData = byteBuffer.readData(length: byteBuffer.readableBytes),
                response.status == .ok else {
                    return self.httpClient.eventLoopGroup.next().makeFailedFuture(OauthRefreshError.noResponse(response.status))
                }
                
                do {
                    return self.httpClient.eventLoopGroup.next().makeSucceededFuture(try self.decoder.decode(OAuthAccessToken.self, from: responseData))
                } catch {
                    return self.httpClient.eventLoopGroup.next().makeFailedFuture(error)
                }
            }
            
        } catch {
            return httpClient.eventLoopGroup.next().makeFailedFuture(error)
        }
    }

    private func generateJWT() throws -> String {
        let payload = OAuthPayload(iss: IssuerClaim(value: credentials.clientEmail),
                                   scope: scope,
                                   aud: AudienceClaim(value: GoogleOAuthTokenAudience),
                                   exp: ExpirationClaim(value: Date().addingTimeInterval(3600)),
                                   iat: IssuedAtClaim(value: Date()))
        let privateKey = try RSAKey.private(pem: credentials.privateKey.data(using: .utf8, allowLossyConversion: true) ?? Data())
        return try JWTSigner.rs256(key: privateKey).sign(payload)
    }
}
