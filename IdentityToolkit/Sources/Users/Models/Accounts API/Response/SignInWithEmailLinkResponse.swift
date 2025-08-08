import Core
import Foundation

public struct SignInWithEmailLinkResponse: GoogleCloudModel {
    /// An Identity Platform ID token for the authenticated user
    public let idToken: String
    /// The email the user signed in with
    public let email: String
    /// Refresh token for the authenticated user
    public let refreshToken: String
    /// The number of seconds until the ID token expires
    public let expiresIn: String
    /// The ID of the authenticated user
    public let localId: String
    /// Whether the authenticated user was created by this request
    public let isNewUser: Bool
    /// Proof that the user has passed the first factor check
    public let mfaPendingCredential: String?
    /// Info on which multi-factor authentication providers are enabled
    public let mfaInfo: [MfaEnrollment]?
    
    // Deprecated fields
    @available(*, deprecated, message: "This field is deprecated")
    public let kind: String?
} 