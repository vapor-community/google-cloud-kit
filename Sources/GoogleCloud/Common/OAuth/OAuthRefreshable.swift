//
//  OAuthRefreshable.swift
//  GoogleCloudProvider
//
//  Created by Brian Hatfield on 7/17/18.
//

import Vapor

// Constants for OAuth URLs. PascalCase style from this suggestion: https://stackoverflow.com/a/31893982
let GoogleOAuthTokenUrl = "https://www.googleapis.com/oauth2/v4/token"
let GoogleOAuthTokenAudience = GoogleOAuthTokenUrl

public protocol OAuthRefreshable {
    func isFresh(token: OAuthAccessToken, created: Date) -> Bool
    func refresh() throws -> Future<OAuthAccessToken>
}

extension OAuthRefreshable {
    public func isFresh(token: OAuthAccessToken, created: Date) -> Bool {
        let now = Date()
        let expiration = created.addingTimeInterval(TimeInterval(token.expiresIn))

        return expiration > now
    }
}
