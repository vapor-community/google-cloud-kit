import Core
import Foundation

public struct SignInWithCustomTokenRequest: GoogleCloudModel {
    /// Required. The custom Auth token asserted by the developer
    public let token: String
    /// Should always be true
    public let returnSecureToken: Bool
    /// The ID of the Identity Platform tenant
    public let tenantId: String?
    
    // Deprecated fields
    @available(*, deprecated, message: "This field is deprecated")
    public let instanceId: String?
    @available(*, deprecated, message: "This field is deprecated")
    public let delegatedProjectNumber: String?
    
    public init(
        token: String,
        returnSecureToken: Bool = true,
        tenantId: String? = nil,
        instanceId: String? = nil,
        delegatedProjectNumber: String? = nil
    ) {
        self.token = token
        self.returnSecureToken = returnSecureToken
        self.tenantId = tenantId
        self.instanceId = instanceId
        self.delegatedProjectNumber = delegatedProjectNumber
    }
} 