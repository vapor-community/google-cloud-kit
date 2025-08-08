import Core
import Foundation

public struct SendOobCodeRequest: GoogleCloudModel {
    /// Required. The type of out-of-band (OOB) code to send
    public let requestType: OobReqType
    /// The account's email address to send the OOB code to
    public var email: String?
    /// The reCAPTCHA response for PASSWORD_RESET requests
    public var captchaResp: String?
    /// The IP address of the caller (required for PASSWORD_RESET)
    public var userIp: String?
    /// The new email address for VERIFY_AND_CHANGE_EMAIL requests
    public var newEmail: String?
    /// An ID token for the account
    public var idToken: String?
    /// The URL to continue after user clicks the email link
    public var continueUrl: String?
    /// iOS bundle ID that can handle the OOB code
    public var iOSBundleId: String?
    /// iOS App Store ID
    public var iOSAppStoreId: String?
    /// Android package name that can handle the OOB code
    public var androidPackageName: String?
    /// Whether to install Android app if not present
    public var androidInstallApp: Bool?
    /// Minimum required Android app version
    public var androidMinimumVersion: String?
    /// Whether the OOB code can be handled in-app
    public var canHandleCodeInApp: Bool?
    /// Tenant ID of the Identity Platform tenant
    public var tenantId: String?
    /// Target Project ID
    public var targetProjectId: String?
    /// Firebase Dynamic Link domain
    public var dynamicLinkDomain: String?
    /// Whether to return the OOB link in response
    public var returnOobLink: Bool?
    /// The client type
    public var clientType: ClientType?
    /// The reCAPTCHA version
    public var recaptchaVersion: RecaptchaVersion?
    
    public init(
        requestType: OobReqType,
        email: String? = nil,
        captchaResp: String? = nil,
        userIp: String? = nil,
        newEmail: String? = nil,
        idToken: String? = nil,
        continueUrl: String? = nil,
        iOSBundleId: String? = nil,
        iOSAppStoreId: String? = nil,
        androidPackageName: String? = nil,
        androidInstallApp: Bool? = nil,
        androidMinimumVersion: String? = nil,
        canHandleCodeInApp: Bool? = nil,
        tenantId: String? = nil,
        targetProjectId: String? = nil,
        dynamicLinkDomain: String? = nil,
        returnOobLink: Bool? = nil,
        clientType: ClientType? = nil,
        recaptchaVersion: RecaptchaVersion? = nil
    ) {
        self.requestType = requestType
        self.email = email
        self.captchaResp = captchaResp
        self.userIp = userIp
        self.newEmail = newEmail
        self.idToken = idToken
        self.continueUrl = continueUrl
        self.iOSBundleId = iOSBundleId
        self.iOSAppStoreId = iOSAppStoreId
        self.androidPackageName = androidPackageName
        self.androidInstallApp = androidInstallApp
        self.androidMinimumVersion = androidMinimumVersion
        self.canHandleCodeInApp = canHandleCodeInApp
        self.tenantId = tenantId
        self.targetProjectId = targetProjectId
        self.dynamicLinkDomain = dynamicLinkDomain
        self.returnOobLink = returnOobLink
        self.clientType = clientType
        self.recaptchaVersion = recaptchaVersion
    }
} 