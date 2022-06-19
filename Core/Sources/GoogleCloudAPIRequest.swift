//
//  GoogleCloudAPIRequest.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 8/5/19.
//

import Foundation
import NIO
import NIOFoundationCompat
import NIOHTTP1
import AsyncHTTPClient

public protocol GoogleCloudAPIRequest: AnyObject {
    var refreshableToken: OAuthRefreshable { get }
    var project: String { get }
    var httpClient: HTTPClient { get }
    var responseDecoder: JSONDecoder { get }
    var currentToken: OAuthAccessToken? { get set }
    var tokenCreatedTime: Date? { get set }
    
    /// As part of an API request this returns a valid OAuth token to use with any of the GoogleAPIs.
    /// - Parameter closure: The closure to be executed with the valid access token.
    func withToken<GoogleCloudModel>(_ closure: @escaping (OAuthAccessToken) -> EventLoopFuture<GoogleCloudModel>) -> EventLoopFuture<GoogleCloudModel>
}

extension GoogleCloudAPIRequest {
    public func withToken<GoogleCloudModel>(_ closure: @escaping (OAuthAccessToken) -> EventLoopFuture<GoogleCloudModel>) -> EventLoopFuture<GoogleCloudModel> {
        guard let token = currentToken,
            let created = tokenCreatedTime,
            refreshableToken.isFresh(token: token, created: created) else {
            return refreshableToken.refresh().flatMap { newToken in
                self.currentToken = newToken
                self.tokenCreatedTime = Date()

                return closure(newToken)
            }
        }

        return closure(token)
    }
}
