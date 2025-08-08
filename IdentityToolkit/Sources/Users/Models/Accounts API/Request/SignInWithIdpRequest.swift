import Core
import Foundation

public struct SignInWithIdpRequest: GoogleCloudModel {
    /// Required. The URL to which the IdP redirects the user back
    public let requestUri: String
    /// The POST body containing IdP credentials
    public let postBody: String
    /// Whether to return the OAuth refresh token from the IdP
    public let returnRefreshToken: Bool?
    /// Session ID from createAuthUri to prevent fixation attacks
    public let sessionId: String?
    /// A valid Identity Platform ID token for linking accounts
    public let idToken: String?
    /// Should always be true
    public let returnSecureToken: Bool?
    /// Whether to return OAuth credentials on certain errors
    public let returnIdpCredential: Bool?
    /// The ID of the Identity Platform tenant
    public let tenantId: String?
    /// Opaque string from previous signInWithIdp response
    public let pendingToken: String?
    
    // Deprecated fields
    @available(*, deprecated, message: "This field is deprecated")
    public let pendingIdToken: String?
    @available(*, deprecated, message: "This field is deprecated")
    public let delegatedProjectNumber: String?
    @available(*, deprecated, message: "This field is deprecated")
    public let autoCreate: Bool?
    
    public init(
        requestUri: String,
        postBody: String,
        returnRefreshToken: Bool? = nil,
        sessionId: String? = nil,
        idToken: String? = nil,
        returnSecureToken: Bool? = true,
        returnIdpCredential: Bool? = nil,
        tenantId: String? = nil,
        pendingToken: String? = nil,
        pendingIdToken: String? = nil,
        delegatedProjectNumber: String? = nil,
        autoCreate: Bool? = nil
    ) {
        self.requestUri = requestUri
        self.postBody = postBody
        self.returnRefreshToken = returnRefreshToken
        self.sessionId = sessionId
        self.idToken = idToken
        self.returnSecureToken = returnSecureToken
        self.returnIdpCredential = returnIdpCredential
        self.tenantId = tenantId
        self.pendingToken = pendingToken
        self.pendingIdToken = pendingIdToken
        self.delegatedProjectNumber = delegatedProjectNumber
        self.autoCreate = autoCreate
    }
} 