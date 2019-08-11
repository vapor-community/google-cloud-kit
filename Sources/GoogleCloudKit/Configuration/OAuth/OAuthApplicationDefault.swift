//
//  OAuthApplicationDefault.swift
//  GoogleCloudProvider
//
//  Created by Brian Hatfield on 7/17/18.
//

import NIO
import NIOFoundationCompat
import NIOHTTP1
import AsyncHTTPClient
import Foundation

public class OAuthApplicationDefault: OAuthRefreshable {
    let httpClient: HTTPClient
    let credentials: GoogleApplicationDefaultCredentials
    private let decoder = JSONDecoder()
    
    init(credentials: GoogleApplicationDefaultCredentials, httpClient: HTTPClient) {
        self.credentials = credentials
        self.httpClient = httpClient
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    // Google Documentation for this approach: https://developers.google.com/identity/protocols/OAuth2WebServer#offline
    public func refresh() -> EventLoopFuture<OAuthAccessToken> {
        do {
            let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
            
            let body: HTTPClient.Body = .string("client_id=\(credentials.clientId)&client_secret=\(credentials.clientSecret)&refresh_token=\(credentials.refreshToken)&grant_type=refresh_token")
            
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
}
