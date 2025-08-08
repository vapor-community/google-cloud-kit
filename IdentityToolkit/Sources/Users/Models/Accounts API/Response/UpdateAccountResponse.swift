import Core
import Foundation

public struct UpdateAccountResponse: GoogleCloudModel {
    /// The user's display name
    public let displayName: String?
    /// The user's email
    public let email: String?
    /// The user's email verification status
    public let emailVerified: Bool?
    /// The user's photo URL
    public let photoUrl: String?
    /// The user's password hash
    public let passwordHash: String?
    /// The user's password salt
    public let salt: String?
    /// The user's phone number
    public let phoneNumber: String?
    /// The user's last login timestamp
    public let lastLoginAt: String?
    /// The user's ID token
    public let idToken: String?
    /// The user's refresh token
    public let refreshToken: String?
    /// The token expiration time
    public let expiresIn: String?
    /// The user's local ID
    public let localId: String?
    
    // Deprecated fields
    @available(*, deprecated, message: "This field is deprecated")
    public let kind: String?
} 