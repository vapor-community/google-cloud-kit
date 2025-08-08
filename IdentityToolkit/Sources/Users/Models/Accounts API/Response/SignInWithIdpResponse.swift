import Core
import Foundation

public struct SignInWithIdpResponse: GoogleCloudModel {
    /// The user's account ID at the IdP
    public let federatedId: String
    /// The provider ID of the IdP
    public let providerId: String
    /// The email address of the user's account at the IdP
    public let email: String?
    /// Whether the user account's email is verified
    public let emailVerified: Bool?
    /// The first name for the user's account
    public let firstName: String?
    /// The full name for the user's account
    public let fullName: String?
    /// The last name for the user's account
    public let lastName: String?
    /// The nickname for the user's account
    public let nickName: String?
    /// The language preference for the user's account
    public let language: String?
    /// The time zone for the user's account
    public let timeZone: String?
    /// The URL of the user's profile picture
    public let photoUrl: String?
    /// The date of birth for the user's account
    public let dateOfBirth: String?
    /// The main email address of the Identity Platform account
    public let originalEmail: String?
    /// The ID of the authenticated Identity Platform user
    public let localId: String
    /// Whether there's an existing account with same email
    public let emailRecycled: Bool?
    /// The display name for the user's account
    public let displayName: String?
    /// An Identity Platform ID token
    public let idToken: String
    /// Contextual information between requests
    public let context: String?
    /// List of provider IDs for needConfirmation
    public let verifiedProvider: [String]?
    /// Whether user needs to confirm account linking
    public let needConfirmation: Bool?
    /// The OAuth access token from the IdP
    public let oauthAccessToken: String?
    /// The OAuth refresh token from the IdP
    public let oauthRefreshToken: String?
    /// OAuth access token expiration time
    public let oauthExpireIn: Int?
    /// The OAuth authorization code (Google only)
    public let oauthAuthorizationCode: String?
    /// The OAuth token secret (Twitter only)
    public let oauthTokenSecret: String?
    /// An Identity Platform refresh token
    public let refreshToken: String?
    /// Identity Platform ID token expiration time
    public let expiresIn: String?
    /// The OpenID Connect ID token from the IdP
    public let oauthIdToken: String?
    /// Screen name or login name
    public let screenName: String?
    /// Raw user info from IdP
    public let rawUserInfo: String?
    /// Error message for returnIdpCredential
    public let errorMessage: String?
    /// Whether a new account was created
    public let isNewUser: Bool?
    /// Opaque token for future sign-ins
    public let pendingToken: String?
    /// The tenant ID from the request
    public let tenantId: String?
    /// Proof of first factor completion
    public let mfaPendingCredential: String?
    /// MFA provider information
    public let mfaInfo: [MfaEnrollment]?
    
    // Deprecated fields
    @available(*, deprecated, message: "This field is deprecated")
    public let inputEmail: String?
    @available(*, deprecated, message: "This field is deprecated")
    public let needEmail: Bool?
    @available(*, deprecated, message: "This field is deprecated")
    public let kind: String?
} 