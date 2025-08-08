import Core
import Foundation

public struct SignInWithPasswordRequest: GoogleCloudModel {
    /// Required. The email the user is signing in with
    public let email: String
    /// Required. The password the user provides
    public let password: String
    /// The reCAPTCHA token
    public let captchaResponse: String?
    /// Should always be true
    public let returnSecureToken: Bool?
    /// The ID of the Identity Platform tenant
    public let tenantId: String?
    /// The client type (required when reCAPTCHA Enterprise is enabled)
    public let clientType: ClientType?
    /// The reCAPTCHA version
    public let recaptchaVersion: RecaptchaVersion?
    
    // Deprecated fields
    @available(*, deprecated, message: "This field is deprecated")
    public let pendingIdToken: String?
    @available(*, deprecated, message: "This field is deprecated")
    public let captchaChallenge: String?
    @available(*, deprecated, message: "This field is deprecated")
    public let instanceId: String?
    @available(*, deprecated, message: "This field is deprecated")
    public let delegatedProjectNumber: String?
    @available(*, deprecated, message: "This field is deprecated")
    public let idToken: String?
    
    public init(
        email: String,
        password: String,
        captchaResponse: String? = nil,
        returnSecureToken: Bool? = true,
        tenantId: String? = nil,
        clientType: ClientType? = nil,
        recaptchaVersion: RecaptchaVersion? = nil,
        pendingIdToken: String? = nil,
        captchaChallenge: String? = nil,
        instanceId: String? = nil,
        delegatedProjectNumber: String? = nil,
        idToken: String? = nil
    ) {
        self.email = email
        self.password = password
        self.captchaResponse = captchaResponse
        self.returnSecureToken = returnSecureToken
        self.tenantId = tenantId
        self.clientType = clientType
        self.recaptchaVersion = recaptchaVersion
        self.pendingIdToken = pendingIdToken
        self.captchaChallenge = captchaChallenge
        self.instanceId = instanceId
        self.delegatedProjectNumber = delegatedProjectNumber
        self.idToken = idToken
    }
} 