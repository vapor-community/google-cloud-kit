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
        let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
 
        return generateJWT(on: self.eventLoop).flatMapThrowing { (token: String) -> HTTPClient.Request in
            let body: HTTPClient.Body = .string("grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=\(token)"
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            
            return try HTTPClient.Request(url: GoogleOAuthTokenUrl, method: .POST, headers: headers, body: body)
        }.flatMap { request in
            return self.httpClient.execute(request: request, eventLoop: .delegate(on: self.eventLoop))
        }.flatMap { (response: HTTPClient.Response) in
            guard var byteBuffer = response.body,
            let responseData = byteBuffer.readData(length: byteBuffer.readableBytes),
            response.status == .ok else {
                return self.eventLoop.makeFailedFuture(OauthRefreshError.noResponse(response.status))
            }
            
            do {
                return self.eventLoop.makeSucceededFuture(try self.decoder.decode(OAuthAccessToken.self, from: responseData))
            } catch {
                return self.eventLoop.makeFailedFuture(error)
            }
        }
    }

    private func generateJWT(on eventLoop: EventLoop) -> EventLoopFuture<String> {
        let payload = OAuthPayload(iss: IssuerClaim(value: credentials.clientEmail),
                                   scope: scope,
                                   aud: AudienceClaim(value: GoogleOAuthTokenAudience),
                                   exp: ExpirationClaim(value: Date().addingTimeInterval(3600)),
                                   iat: IssuedAtClaim(value: Date()), sub: subscription)
        
        let privateKey: Insecure.RSA.PrivateKey
        do {
            privateKey = try Insecure.RSA.PrivateKey(pem: credentials.privateKey.data(using: .utf8, allowLossyConversion: true) ?? Data())
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
        
        return eventLoop.makeFutureWithTask { try await JWTKeyCollection().addRS256(key: privateKey).sign(payload) }
    }
}
