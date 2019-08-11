//
//  OAuthPayload.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 4/15/18.
//

import JWTKit

/// The payload for requesting an OAuth token to make API calls to Google APIs.
/// https://developers.google.com/identity/protocols/OAuth2ServiceAccount#authorizingrequests
public struct OAuthPayload: JWTPayload {
    /// The email address of the service account.
    var iss: IssuerClaim
    /// A space-delimited list of the permissions that the application requests.
    var scope: String
    /// A descriptor of the intended target of the assertion. When making an access token request this value is always https://www.googleapis.com/oauth2/v4/token.
    var aud: AudienceClaim
    /// The expiration time of the assertion, specified as seconds since 00:00:00 UTC, January 1, 1970. This value has a maximum of 1 hour after the issued time.
    var exp: ExpirationClaim
    /// The time the assertion was issued, specified as seconds since 00:00:00 UTC, January 1, 1970.
    var iat: IssuedAtClaim
    
    public func verify(using signer: JWTSigner) throws {
        try exp.verifyNotExpired()
    }
}
