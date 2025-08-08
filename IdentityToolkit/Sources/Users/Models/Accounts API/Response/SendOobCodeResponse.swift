import Core
import Foundation

public struct SendOobCodeResponse: GoogleCloudModel {
    /// The email address that the email was sent to
    public let email: String
    /// The OOB code itself, only returned if returnOobLink was true
    public let oobCode: String?
    /// The OOB link, only returned if returnOobLink was true
    public let oobLink: String?
} 