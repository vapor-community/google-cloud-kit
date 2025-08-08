import Core
import Foundation

public struct VerifyIosClientRequest: GoogleCloudModel {
    /// A device token from APNs registration
    public let appToken: String
    /// Whether the app token is in the iOS sandbox
    public let isSandbox: Bool
    
    public init(
        appToken: String,
        isSandbox: Bool
    ) {
        self.appToken = appToken
        self.isSandbox = isSandbox
    }
} 