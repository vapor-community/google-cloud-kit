//
//  OAuthAccessToken.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 4/15/18.
//

import Foundation

/// An access token returned from the authorization server used to authenticate against Google APIs.
public struct OAuthAccessToken: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
}
