import Core
import Foundation

public struct SignInWithCustomTokenResponse: GoogleCloudModel {
    /// An Identity Platform ID token for the authenticated user
    public let idToken: String
    /// An Identity Platform refresh token for the authenticated user
    public let refreshToken: String
    /// The number of seconds until the ID token expires
    public let expiresIn: String
    /// Whether the authenticated user was created by this request
    public let isNewUser: Bool
    
    // Deprecated fields
    @available(*, deprecated, message: "This field is deprecated")
    public let kind: String?
} 