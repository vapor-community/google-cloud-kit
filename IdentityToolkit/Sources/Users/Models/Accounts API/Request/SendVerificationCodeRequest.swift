import Core
import Foundation

public struct SendVerificationCodeRequest: GoogleCloudModel {
    /// The phone number to send the verification code to in E.164 format
    public let phoneNumber: String
    
    /// Receipt of successful iOS app token validation
    public var iosReceipt: String?
    
    /// Secret delivered to iOS app as a push notification
    public var iosSecret: String?
    
    /// Recaptcha token for app verification
    public var recaptchaToken: String?
    
    /// Tenant ID of the Identity Platform tenant the user is signing in to
    public var tenantId: String?
    
    /// Android only. Used by Google Play Services to identify the app for auto-retrieval
    public var autoRetrievalInfo: AutoRetrievalInfo?
    
    /// Android only. Used to assert application identity in place of a recaptcha token
    public var safetyNetToken: String?
    
    /// Android only. Used to assert application identity in place of a recaptcha token
    public var playIntegrityToken: String?
    
    /// The reCAPTCHA Enterprise token
    public var captchaResponse: String?
    
    /// The client type (web, android or ios)
    public var clientType: ClientType?
    
    /// The reCAPTCHA version
    public var recaptchaVersion: RecaptchaVersion?
    
    public init(
        phoneNumber: String,
        iosReceipt: String? = nil,
        iosSecret: String? = nil,
        recaptchaToken: String? = nil,
        tenantId: String? = nil,
        autoRetrievalInfo: AutoRetrievalInfo? = nil,
        safetyNetToken: String? = nil,
        playIntegrityToken: String? = nil,
        captchaResponse: String? = nil,
        clientType: ClientType? = nil,
        recaptchaVersion: RecaptchaVersion? = nil
    ) {
        self.phoneNumber = phoneNumber
        self.iosReceipt = iosReceipt
        self.iosSecret = iosSecret
        self.recaptchaToken = recaptchaToken
        self.tenantId = tenantId
        self.autoRetrievalInfo = autoRetrievalInfo
        self.safetyNetToken = safetyNetToken
        self.playIntegrityToken = playIntegrityToken
        self.captchaResponse = captchaResponse
        self.clientType = clientType
        self.recaptchaVersion = recaptchaVersion
    }
}