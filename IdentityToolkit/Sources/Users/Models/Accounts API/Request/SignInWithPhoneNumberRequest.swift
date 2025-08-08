import Core
import Foundation

public struct SignInWithPhoneNumberRequest: GoogleCloudModel {
    /// Encrypted session information from sendVerificationCode
    public let sessionInfo: String?
    /// The user's phone number to sign in with
    public let phoneNumber: String?
    /// User-entered verification code from SMS
    public let code: String?
    /// A proof of the phone number verification
    public let temporaryProof: String?
    /// A valid ID token for linking accounts
    public let idToken: String?
    /// The ID of the Identity Platform tenant
    public let tenantId: String?
    
    // Deprecated fields
    @available(*, deprecated, message: "This field is deprecated")
    public let verificationProof: String?
    @available(*, deprecated, message: "This field is deprecated")
    public let operation: VerifyOp?
    
    public init(
        sessionInfo: String? = nil,
        phoneNumber: String? = nil,
        code: String? = nil,
        temporaryProof: String? = nil,
        idToken: String? = nil,
        tenantId: String? = nil,
        verificationProof: String? = nil,
        operation: VerifyOp? = nil
    ) {
        self.sessionInfo = sessionInfo
        self.phoneNumber = phoneNumber
        self.code = code
        self.temporaryProof = temporaryProof
        self.idToken = idToken
        self.tenantId = tenantId
        self.verificationProof = verificationProof
        self.operation = operation
    }
} 