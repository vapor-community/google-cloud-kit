//
//  OAuthRefreshable.swift
//  GoogleCloudProvider
//
//  Created by Brian Hatfield on 7/17/18.
//

import Foundation
import NIO

// Constants for OAuth URLs. PascalCase style from this suggestion: https://stackoverflow.com/a/31893982
let GoogleOAuthTokenUrl = "https://www.googleapis.com/oauth2/v4/token"
let GoogleOAuthTokenAudience = GoogleOAuthTokenUrl

public protocol OAuthRefreshable {
    func isFresh(token: OAuthAccessToken, created: Date) -> Bool
    func refresh() -> EventLoopFuture<OAuthAccessToken>
}

extension OAuthRefreshable {
    public func isFresh(token: OAuthAccessToken, created: Date) -> Bool {
        let now = Date()
        // Check if the token is about to expire within the next 15 seconds.
        // This gives us a buffer and avoids being too close to the expiration when making requests.
        let expiration = created.addingTimeInterval(TimeInterval(token.expiresIn - 15))

        return expiration > now
    }
}
