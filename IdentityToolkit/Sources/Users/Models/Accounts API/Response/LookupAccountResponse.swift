import Core
import Foundation

public struct LookupAccountResponse: GoogleCloudModel {
    /// The user accounts that match the request
    public let users: [UserInfo]?
}

public struct UserInfo: GoogleCloudModel {
    /// The user's ID
    public let localId: String
    /// The user's email
    public let email: String?
    /// Whether the user's email is verified
    public let emailVerified: Bool?
    /// The user's display name
    public let displayName: String?
    /// URL of the user's profile picture
    public let photoUrl: String?
    /// The user's phone number
    public let phoneNumber: String?
    /// When the user was last active
    public let lastLoginAt: String?
    /// When the user was created
    public let createdAt: String?
    /// Custom claims set on the user
    public let customAttributes: String?
    /// Whether the user is disabled
    public let disabled: Bool?
    /// Tenant ID of the user
    public let tenantId: String?
    /// Initial email address used to create the account
    public let initialEmail: String?
    /// The user's password hash
    public let passwordHash: String?
    /// The user's password salt
    public let salt: String?
    /// When the password was last updated
    public let passwordUpdatedAt: Double?
    /// Provider user info
    public let providerUserInfo: [ProviderUserInfo]?
    /// MFA related information
    public let mfaInfo: [MfaInfo]?
    /// When the user was last refreshed
    public let lastRefreshAt: String?
}
