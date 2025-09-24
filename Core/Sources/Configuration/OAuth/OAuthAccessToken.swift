//
//  OAuthAccessToken.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 4/15/18.
//

import Foundation

/// An access token returned from the authorization server used to authenticate against Google APIs.
public struct OAuthAccessToken: Codable, Sendable {
    public let accessToken: String
    public let tokenType: String
    public let expiresIn: Int
}
