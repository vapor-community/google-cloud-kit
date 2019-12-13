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
    private let eventLoop: EventLoop
    
    init(credentials: GoogleApplicationDefaultCredentials, httpClient: HTTPClient, eventLoop: EventLoop) {
        self.credentials = credentials
        self.httpClient = httpClient
        self.eventLoop = eventLoop
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    // Google Documentation for this approach: https://developers.google.com/identity/protocols/OAuth2WebServer#offline
    public func refresh() -> EventLoopFuture<OAuthAccessToken> {
        do {
            let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
            
            let body: HTTPClient.Body = .string("client_id=\(credentials.clientId)&client_secret=\(credentials.clientSecret)&refresh_token=\(credentials.refreshToken)&grant_type=refresh_token")
            
            let request = try HTTPClient.Request(url: GoogleOAuthTokenUrl, method: .POST, headers: headers, body: body)
            
            return httpClient.execute(request: request, eventLoop: .delegate(on: self.eventLoop)).flatMap { response in
                
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
        } catch {
            return self.eventLoop.makeFailedFuture(error)
        }
    }
}
