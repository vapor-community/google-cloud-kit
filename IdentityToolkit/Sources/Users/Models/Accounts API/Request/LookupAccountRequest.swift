import Core
import Foundation

public struct LookupAccountRequest: GoogleCloudModel {
    /// The Identity Platform ID token of the account to fetch
    public let idToken: String?
    /// The IDs of accounts to fetch
    public let localId: [String]?
    /// The email addresses of accounts to fetch
    public let email: [String]?
    /// The phone numbers of accounts to fetch
    public let phoneNumber: [String]?
    /// The federated user identifiers of accounts to fetch
    public let federatedUserId: [FederatedUserIdentifier]?
    /// The ID of the tenant that the account belongs to
    public let tenantId: String?
    /// The ID of the Google Cloud project
    public let targetProjectId: String?
    /// The initial email addresses of accounts to fetch
    public let initialEmail: [String]?
    
    // Deprecated fields
    @available(*, deprecated, message: "This field is deprecated")
    public let delegatedProjectNumber: String?
    
    public init(
        idToken: String? = nil,
        localId: [String]? = nil,
        email: [String]? = nil,
        phoneNumber: [String]? = nil,
        federatedUserId: [FederatedUserIdentifier]? = nil,
        tenantId: String? = nil,
        targetProjectId: String? = nil,
        initialEmail: [String]? = nil,
        delegatedProjectNumber: String? = nil
    ) {
        self.idToken = idToken
        self.localId = localId
        self.email = email
        self.phoneNumber = phoneNumber
        self.federatedUserId = federatedUserId
        self.tenantId = tenantId
        self.targetProjectId = targetProjectId
        self.initialEmail = initialEmail
        self.delegatedProjectNumber = delegatedProjectNumber
    }
} 