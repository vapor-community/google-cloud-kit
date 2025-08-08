import Core
import Foundation

public struct MfaFactor: GoogleCloudModel {
    /// Display name for this MFA option
    public let displayName: String?
    /// Phone number to receive OTP for MFA
    public let phoneInfo: String?
    
    public init(
        displayName: String? = nil,
        phoneInfo: String? = nil
    ) {
        self.displayName = displayName
        self.phoneInfo = phoneInfo
    }
} 