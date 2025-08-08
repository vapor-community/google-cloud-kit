import Core
import Foundation

public struct ResetPasswordResponse: GoogleCloudModel {
    /// The email associated with the out-of-band code
    public let email: String?
    /// The new email address
    public let newEmail: String?
    /// The type of OOB request
    public let requestType: OobReqType?
    /// MFA enrollment information
    public let mfaInfo: MfaEnrollment?
    
    // Deprecated fields
    @available(*, deprecated, message: "This field is deprecated")
    public let kind: String?
}

public struct MfaEnrollment: GoogleCloudModel {
    /// ID of this MFA option
    public let mfaEnrollmentId: String
    /// Display name for this MFA option
    public let displayName: String?
    /// When the account enrolled this second factor
    public let enrolledAt: String
    
    // MFA value (only one will be set)
    /// Phone number (may be obfuscated)
    public let phoneInfo: String?
    /// TOTP MFA information
    public let totpInfo: TotpInfo?
    /// Email MFA information
    public let emailInfo: EmailInfo?
    
    // Unobfuscated values (only one will be set)
    /// Unobfuscated phone number
    public let unobfuscatedPhoneInfo: String?
}

public struct TotpInfo: GoogleCloudModel {
    // This type has no fields
}

public struct EmailInfo: GoogleCloudModel {
    /// Email address for MFA verification
    public let emailAddress: String
} 