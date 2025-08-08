import Core
import Foundation

public struct SignUpRequest: GoogleCloudModel {
    /// The email to assign to the created user
    public let email: String?
    /// The password to assign to the created user
    public let password: String?
    /// The display name of the user
    public let displayName: String?
    /// The reCAPTCHA token
    public let captchaResponse: String?
    /// A valid ID token for linking credentials
    public let idToken: String?
    /// Whether the user's email is verified
    public let emailVerified: Bool?
    /// The profile photo url of the user
    public let photoUrl: String?
    /// Whether the user will be disabled
    public let disabled: Bool?
    /// The ID of the user to create
    public let localId: String?
    /// The phone number of the user
    public let phoneNumber: String?
    /// The ID of the Identity Platform tenant
    public let tenantId: String?
    /// The project ID of the target project
    public let targetProjectId: String?
    /// The multi-factor authentication providers
    public let mfaInfo: [MfaFactor]?
    /// The client type (required for reCAPTCHA Enterprise)
    public let clientType: ClientType?
    /// The reCAPTCHA version
    public let recaptchaVersion: RecaptchaVersion?
    
    // Deprecated fields
    @available(*, deprecated, message: "This field is deprecated")
    public let captchaChallenge: String?
    @available(*, deprecated, message: "This field is deprecated")
    public let instanceId: String?
    
    public init(
        email: String? = nil,
        password: String? = nil,
        displayName: String? = nil,
        captchaResponse: String? = nil,
        idToken: String? = nil,
        emailVerified: Bool? = nil,
        photoUrl: String? = nil,
        disabled: Bool? = nil,
        localId: String? = nil,
        phoneNumber: String? = nil,
        tenantId: String? = nil,
        targetProjectId: String? = nil,
        mfaInfo: [MfaFactor]? = nil,
        clientType: ClientType? = nil,
        recaptchaVersion: RecaptchaVersion? = nil,
        captchaChallenge: String? = nil,
        instanceId: String? = nil
    ) {
        self.email = email
        self.password = password
        self.displayName = displayName
        self.captchaResponse = captchaResponse
        self.idToken = idToken
        self.emailVerified = emailVerified
        self.photoUrl = photoUrl
        self.disabled = disabled
        self.localId = localId
        self.phoneNumber = phoneNumber
        self.tenantId = tenantId
        self.targetProjectId = targetProjectId
        self.mfaInfo = mfaInfo
        self.clientType = clientType
        self.recaptchaVersion = recaptchaVersion
        self.captchaChallenge = captchaChallenge
        self.instanceId = instanceId
    }
} 