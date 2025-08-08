import Core
import Foundation

public struct SignInWithPasswordResponse: GoogleCloudModel {
    /// The ID of the authenticated user
    public let localId: String
    /// The email of the authenticated user
    public let email: String
    /// The user's display name
    public let displayName: String?
    /// An Identity Platform ID token
    public let idToken: String
    /// The user's profile picture
    public let profilePicture: String?
    /// An Identity Platform refresh token
    public let refreshToken: String?
    /// The number of seconds until the ID token expires
    public let expiresIn: String?
    /// Proof of first factor completion
    public let mfaPendingCredential: String?
    /// MFA provider information
    public let mfaInfo: [MfaEnrollment]?
    /// Warning notifications for the user
    public let userNotifications: [UserNotification]?
    
    // Deprecated fields
    @available(*, deprecated, message: "This field is deprecated")
    public let kind: String?
    @available(*, deprecated, message: "This field is deprecated")
    public let registered: Bool?
    @available(*, deprecated, message: "This field is deprecated")
    public let oauthAccessToken: String?
    @available(*, deprecated, message: "This field is deprecated")
    public let oauthExpireIn: Int?
    @available(*, deprecated, message: "This field is deprecated")
    public let oauthAuthorizationCode: String?
} 