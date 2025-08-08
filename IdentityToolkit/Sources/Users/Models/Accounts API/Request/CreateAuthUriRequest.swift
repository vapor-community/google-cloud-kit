import Core
import Foundation

public struct CreateAuthUriRequest: GoogleCloudModel {
    /// The email identifier of the user account
    public let identifier: String?
    /// A valid URL for the IdP to redirect the user back to
    public let continueUri: String?
    /// The provider ID of the IdP for the user to sign in with
    public let providerId: String?
    /// Additional OAuth 2.0 scopes for the IdP
    public let oauthScope: String?
    /// Contextual information between auth request and callback
    public let context: String?
    /// The G Suite hosted domain of the user (Google provider only)
    public let hostedDomain: String?
    /// Session ID to prevent fixation attacks
    public let sessionId: String?
    /// Authentication flow type (Google provider only)
    public let authFlowType: String?
    /// Additional custom query parameters
    public let customParameter: [String: String]?
    /// The ID of the Identity Platform tenant
    public let tenantId: String?
    
    // Deprecated fields
    @available(*, deprecated, message: "This field is deprecated")
    public let openidRealm: String?
    @available(*, deprecated, message: "This field is deprecated")
    public let oauthConsumerKey: String?
    @available(*, deprecated, message: "This field is deprecated")
    public let otaApp: String?
    @available(*, deprecated, message: "This field is deprecated")
    public let appId: String?
    
    public init(
        identifier: String? = nil,
        continueUri: String? = nil,
        providerId: String? = nil,
        oauthScope: String? = nil,
        context: String? = nil,
        hostedDomain: String? = nil,
        sessionId: String? = nil,
        authFlowType: String? = nil,
        customParameter: [String: String]? = nil,
        tenantId: String? = nil,
        openidRealm: String? = nil,
        oauthConsumerKey: String? = nil,
        otaApp: String? = nil,
        appId: String? = nil
    ) {
        self.identifier = identifier
        self.continueUri = continueUri
        self.providerId = providerId
        self.oauthScope = oauthScope
        self.context = context
        self.hostedDomain = hostedDomain
        self.sessionId = sessionId
        self.authFlowType = authFlowType
        self.customParameter = customParameter
        self.tenantId = tenantId
        self.openidRealm = openidRealm
        self.oauthConsumerKey = oauthConsumerKey
        self.otaApp = otaApp
        self.appId = appId
    }
} 