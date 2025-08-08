import Core
import Foundation

public struct SignInWithEmailLinkRequest: GoogleCloudModel {
    /// Required. The out-of-band code from the email link
    public let oobCode: String
    /// Required. The email address the sign-in link was sent to
    public let email: String
    /// A valid ID token for an Identity Platform account
    public let idToken: String?
    /// The ID of the Identity Platform tenant
    public let tenantId: String?
    
    public init(
        oobCode: String,
        email: String,
        idToken: String? = nil,
        tenantId: String? = nil
    ) {
        self.oobCode = oobCode
        self.email = email
        self.idToken = idToken
        self.tenantId = tenantId
    }
} 