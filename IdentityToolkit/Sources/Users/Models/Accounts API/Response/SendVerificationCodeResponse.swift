import Core
import Foundation

public struct SendVerificationCodeResponse: GoogleCloudModel {
    /// Encrypted session information. This can be used in signInWithPhoneNumber to authenticate the phone number
    public let sessionInfo: String
} 