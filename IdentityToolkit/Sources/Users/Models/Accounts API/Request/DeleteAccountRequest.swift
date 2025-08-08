import Core
import Foundation

public struct DeleteAccountRequest: GoogleCloudModel {
    /// The ID of user account to delete
    public let localId: String?
    /// The Identity Platform ID token of the account to delete
    public let idToken: String?
    /// The ID of the tenant that the account belongs to
    public let tenantId: String?
    /// The ID of the project which the account belongs to
    public let targetProjectId: String?
    
    // Deprecated fields
    @available(*, deprecated, message: "This field is deprecated")
    public let delegatedProjectNumber: String?
    
    public init(
        localId: String? = nil,
        idToken: String? = nil,
        tenantId: String? = nil,
        targetProjectId: String? = nil,
        delegatedProjectNumber: String? = nil
    ) {
        self.localId = localId
        self.idToken = idToken
        self.tenantId = tenantId
        self.targetProjectId = targetProjectId
        self.delegatedProjectNumber = delegatedProjectNumber
    }
} 