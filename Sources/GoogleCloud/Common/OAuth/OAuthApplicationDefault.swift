//
//  OAuthApplicationDefault.swift
//  GoogleCloudProvider
//
//  Created by Brian Hatfield on 7/17/18.
//

import Vapor
import Crypto
import JWT

public class OAuthApplicationDefault: OAuthRefreshable {
    let client: Client
    let credentials: GoogleApplicationDefaultCredentials

    init(credentials: GoogleApplicationDefaultCredentials, httpClient: Client) {
        self.credentials = credentials
        self.client = httpClient
    }

    // Google Documentation for this approach: https://developers.google.com/identity/protocols/OAuth2WebServer#offline
    public func refresh() throws -> Future<OAuthAccessToken> {
        let headers: HTTPHeaders = ["Content-Type": MediaType.urlEncodedForm.description]

        let encoder = URLEncodedFormEncoder()

        let bodyParts = [
            "client_id": credentials.clientId,
            "client_secret": credentials.clientSecret,
            "refresh_token": credentials.refreshToken,
            "grant_type": "refresh_token",
        ]

        let body = try encoder.encode(bodyParts)

        return client.post(GoogleOAuthTokenUrl, headers: headers, beforeSend: { $0.http.body = HTTPBody(data: body) }).flatMap(to: OAuthAccessToken.self) { (response) in
            if response.http.status == .ok {
                return try JSONDecoder().decode(OAuthAccessToken.self, from: response.http, maxSize: 65_536, on: response)
            }
            throw Abort(response.http.status, reason: "An unexpected error occured when attempting to refresh GoogleOAuth token.")
        }
    }
}
