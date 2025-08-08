import Core
import Foundation

public struct SignUpResponse: GoogleCloudModel {
    /// The ID of the authenticated user
    public let localId: String
    /// The email of the authenticated user
    public let email: String?
    /// The display name of the user
    public let displayName: String?
    /// An Identity Platform ID token
    public let idToken: String?
    /// The refresh token for the user
    public let refreshToken: String?
    /// The number of seconds until the ID token expires
    public let expiresIn: String?
    
    // Deprecated fields
    @available(*, deprecated, message: "This field is deprecated")
    public let kind: String?
} 