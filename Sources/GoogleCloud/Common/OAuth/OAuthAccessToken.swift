//
//  OAuthResponse.swift
//  GoogleCloudProvider
//
//  Created by Andrew Edwards on 4/15/18.
//

import Vapor

public struct OAuthAccessToken: Content {
    var accessToken: String
    var tokenType: String
    var expiresIn: Int
    
    public enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}
