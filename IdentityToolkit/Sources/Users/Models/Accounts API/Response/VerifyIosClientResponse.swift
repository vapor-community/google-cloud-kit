import Core
import Foundation

public struct VerifyIosClientResponse: GoogleCloudModel {
    /// Receipt of successful app token validation
    public let receipt: String
    /// Suggested wait time in seconds for push notification delivery
    public let suggestedTimeout: String
} 