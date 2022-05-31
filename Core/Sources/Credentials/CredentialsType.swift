//
//  CredentialsType.swift
//  
//
//  Created by Andrew Edwards on 2/19/22.
//

import Foundation

public enum CredentialsType {
    case gcloud
    case serviceAccount
}

public enum ResolvedCredentials {
    case gcloud(GCloudCredentials)
    case serviceAccount(ServiceAccountCredentials)
    case computeEngine(String)
}

public protocol AccessTokenProvider {
    func getAccessToken() async throws -> String
}

/// An access token returned from the authorization server used to authenticate against Google APIs.
public struct AccessToken: Codable {
    /// The access token used for making requests to google APIs
    public let accessToken: String
    /// The type of token
    public let tokenType: String
    /// The number of seconds until this token is expired.
    public let expiresIn: Int
}

public struct IDToken: Codable {
    /// The id token
    public let idToken: String
}
