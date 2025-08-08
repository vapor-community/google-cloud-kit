import Core
import Foundation

public struct UpdateAccountRequest: GoogleCloudModel {
    /// A valid Identity Platform ID token
    public let idToken: String?
    /// The ID of the user
    public let localId: String?
    /// The user's new display name
    public let displayName: String?
    /// The user's new email
    public let email: String?
    /// The user's new password
    public let password: String?
    /// The Identity Providers to associate
    public let provider: [String]?
    /// The out-of-band code to apply
    public let oobCode: String?
    /// Whether the user's email is verified
    public let emailVerified: Bool?
    /// Whether to restrict to federated login
    public let upgradeToFederatedLogin: Bool?
    /// The reCAPTCHA response
    public let captchaResponse: String?
    /// Minimum timestamp for valid tokens
    public let validSince: String?
    /// Whether to disable the account
    public let disableUser: Bool?
    /// The user's new photo URL
    public let photoUrl: String?
    /// The account's attributes to delete
    public let deleteAttribute: [UserAttributeName]?
    /// Whether to return tokens
    public let returnSecureToken: Bool?
    /// The Identity Providers to unlink
    public let deleteProvider: [String]?
    /// When the account last logged in
    public let lastLoginAt: String?
    /// When the account was created
    public let createdAt: String?
    /// The phone number to update
    public let phoneNumber: String?
    /// Custom attributes for the ID token
    public let customAttributes: String?
    /// The tenant ID
    public let tenantId: String?
    /// The project ID
    public let targetProjectId: String?
    /// The MFA information to set
    public let mfa: MfaInfo?
    /// The provider to link
    public let linkProviderUserInfo: ProviderUserInfo?
    
    // Deprecated fields
    @available(*, deprecated, message: "This field is deprecated")
    public let captchaChallenge: String?
    @available(*, deprecated, message: "This field is deprecated")
    public let instanceId: String?
    @available(*, deprecated, message: "This field is deprecated")
    public let delegatedProjectNumber: String?
    
    public init(
        idToken: String? = nil,
        localId: String? = nil,
        displayName: String? = nil,
        email: String? = nil,
        password: String? = nil,
        provider: [String]? = nil,
        oobCode: String? = nil,
        emailVerified: Bool? = nil,
        upgradeToFederatedLogin: Bool? = nil,
        captchaResponse: String? = nil,
        validSince: String? = nil,
        disableUser: Bool? = nil,
        photoUrl: String? = nil,
        deleteAttribute: [UserAttributeName]? = nil,
        returnSecureToken: Bool? = nil,
        deleteProvider: [String]? = nil,
        lastLoginAt: String? = nil,
        createdAt: String? = nil,
        phoneNumber: String? = nil,
        customAttributes: String? = nil,
        tenantId: String? = nil,
        targetProjectId: String? = nil,
        mfa: MfaInfo? = nil,
        linkProviderUserInfo: ProviderUserInfo? = nil,
        captchaChallenge: String? = nil,
        instanceId: String? = nil,
        delegatedProjectNumber: String? = nil
    ) {
        self.idToken = idToken
        self.localId = localId
        self.displayName = displayName
        self.email = email
        self.password = password
        self.provider = provider
        self.oobCode = oobCode
        self.emailVerified = emailVerified
        self.upgradeToFederatedLogin = upgradeToFederatedLogin
        self.captchaResponse = captchaResponse
        self.validSince = validSince
        self.disableUser = disableUser
        self.photoUrl = photoUrl
        self.deleteAttribute = deleteAttribute
        self.returnSecureToken = returnSecureToken
        self.deleteProvider = deleteProvider
        self.lastLoginAt = lastLoginAt
        self.createdAt = createdAt
        self.phoneNumber = phoneNumber
        self.customAttributes = customAttributes
        self.tenantId = tenantId
        self.targetProjectId = targetProjectId
        self.mfa = mfa
        self.linkProviderUserInfo = linkProviderUserInfo
        self.captchaChallenge = captchaChallenge
        self.instanceId = instanceId
        self.delegatedProjectNumber = delegatedProjectNumber
    }
} 