//
//  GCloudCredentialsProvider.swift
//  
//
//  Created by Andrew Edwards on 2/19/22.
//

import Foundation
import AsyncHTTPClient
import NIO

public actor GCloudCredentialsProvider: AccessTokenProvider {
    static let endpoint = "https://oauth2.googleapis.com/token"
    
    let client: HTTPClient
    let credentials: GCloudCredentials
    var accessToken: AccessToken?
    var tokenExpiration: Date?
    let decoder = JSONDecoder()
    
    public init(client: HTTPClient, credentials: GCloudCredentials) {
        self.client = client
        self.credentials = credentials
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    public func getAccessToken() async throws -> String {
        if let existingToken = accessToken,
           let expiration = tokenExpiration {
            if expiration >= Date() {
                return existingToken.accessToken
            } else {
                return try await refresh()
            }
        } else {
            return try await refresh()
        }
    }
    
    private func buildRequest() throws -> HTTPClientRequest {
        var request = HTTPClientRequest(url: Self.endpoint)
        request.method = .POST
        request.headers = ["Content-Type": "application/x-www-form-urlencoded",
                           "X-Goog-User-Project": credentials.quotaProjectId]
        request.body = .bytes(ByteBuffer(string: "client_id=\(credentials.clientId)&client_secret=\(credentials.clientSecret)&refresh_token=\(credentials.refreshToken)&grant_type=refresh_token"))
        return request
    }
    
    @discardableResult
    private func refresh() async throws -> String {
        let response = try await client.execute(buildRequest(), timeout: .seconds(10))
        guard response.status == .ok else {
            throw OauthRefreshError.noResponse(response.status)
        }
        let body = try await response.body.collect(upTo: 1024 * 1024) // 1mb
        
        let token = try decoder.decode(AccessToken.self, from: Data(buffer: body))
        accessToken = token
        // scrape off 5 minutes so we're not runnung up against time boundaries.
        tokenExpiration = Date().addingTimeInterval(TimeInterval(token.expiresIn - 300))
        return token.accessToken
    }
}

/// The gcloud default credentials generated via command ‘gcloud auth application-default login’.
public struct GCloudCredentials: Codable {
    public let clientId: String
    public let clientSecret: String
    public let quotaProjectId: String
    public let refreshToken: String
    public let type: String
}
