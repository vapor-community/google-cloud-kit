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
    public let subscription : String?
    private var eventLoop: EventLoop

    private let decoder = JSONDecoder()
    
    init(credentials: GoogleServiceAccountCredentials, scopes: [GoogleCloudAPIScope], subscription: String?, httpClient: HTTPClient, eventLoop: EventLoop) {
        self.credentials = credentials
        self.scope = scopes.map { $0.value }.joined(separator: " ")
        self.httpClient = httpClient
        self.eventLoop = eventLoop
        self.subscription = subscription
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    // Google Documentation for this approach: https://developers.google.com/identity/protocols/OAuth2ServiceAccount
    public func refresh() -> EventLoopFuture<OAuthAccessToken> {
        let promise = eventLoop.makePromise(of: OAuthAccessToken.self)

        Task {
            do {
                let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
                let token = try await generateJWT()
                let body: HTTPClient.Body = .string("grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=\(token)"
                                            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
                let request = try HTTPClient.Request(url: GoogleOAuthTokenUrl, method: .POST, headers: headers, body: body)

                let response = try await httpClient.execute(request: request, eventLoop: .delegate(on: self.eventLoop)).get()

                guard var byteBuffer = response.body,
                let responseData = byteBuffer.readData(length: byteBuffer.readableBytes),
                response.status == .ok else {
                    promise.fail(OauthRefreshError.noResponse(response.status))
                    return
                }

                let accessToken = try self.decoder.decode(OAuthAccessToken.self, from: responseData)
                promise.succeed(accessToken)

            } catch {
                promise.fail(error)
            }
        }

        return promise.futureResult
    }

    private func generateJWT() async throws -> String {
        let payload = OAuthPayload(iss: IssuerClaim(value: credentials.clientEmail),
                                   scope: scope,
                                   aud: AudienceClaim(value: GoogleOAuthTokenAudience),
                                   exp: ExpirationClaim(value: Date().addingTimeInterval(3600)),
                                   iat: IssuedAtClaim(value: Date()), sub: subscription)

        let privateKeyData = credentials.privateKey.data(using: .utf8, allowLossyConversion: true) ?? Data()
        let privateKey = try Insecure.RSA.PrivateKey(pem: privateKeyData)

        let keyCollection = JWTKeyCollection()
        await keyCollection.add(rsa: privateKey, digestAlgorithm: .sha256)

        return try await keyCollection.sign(payload)
    }
}
