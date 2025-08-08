import Core
import Foundation

public enum RecaptchaVersion: String, GoogleCloudModel {
    case v2 = "RECAPTCHA_V2"
    case v3 = "RECAPTCHA_V3"
    case unspecified = "RECAPTCHA_UNSPECIFIED"
    case enterprise = "RECAPTCHA_ENTERPRISE"
} 