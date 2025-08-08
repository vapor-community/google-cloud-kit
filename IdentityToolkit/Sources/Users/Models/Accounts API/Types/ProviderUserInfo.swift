import Core
import Foundation

public struct ProviderUserInfo: GoogleCloudModel {
    /// The ID of the Identity Provider
    public let providerId: String
    /// The user's display name at the Identity Provider
    public let displayName: String?
    /// The user's profile photo URL at the Identity Provider
    public let photoUrl: String?
    /// The user's identifier at the Identity Provider
    public let federatedId: String?
    /// The user's email address at the Identity Provider
    public let email: String?
    /// The user's raw identifier from Identity Provider
    public let rawId: String?
    /// The user's screenName at Twitter or login name at GitHub
    public let screenName: String?
    /// The user's phone number at the Identity Provider
    public let phoneNumber: String?
    
    public init(
        providerId: String,
        displayName: String? = nil,
        photoUrl: String? = nil,
        federatedId: String? = nil,
        email: String? = nil,
        rawId: String? = nil,
        screenName: String? = nil,
        phoneNumber: String? = nil
    ) {
        self.providerId = providerId
        self.displayName = displayName
        self.photoUrl = photoUrl
        self.federatedId = federatedId
        self.email = email
        self.rawId = rawId
        self.screenName = screenName
        self.phoneNumber = phoneNumber
    }
} 