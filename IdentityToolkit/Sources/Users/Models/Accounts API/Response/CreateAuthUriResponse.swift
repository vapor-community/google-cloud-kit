import Core
import Foundation

public struct CreateAuthUriResponse: GoogleCloudModel {
    /// The authorization URI for the requested provider
    public let authUri: String?
    /// Whether the email identifier represents an existing account
    public let registered: Bool?
    /// The provider ID from the request
    public let providerId: String?
    /// Whether the user has previously signed in with this provider
    public let forExistingProvider: Bool?
    /// Whether a CAPTCHA is needed due to too many failed attempts
    public let captchaRequired: Bool?
    /// The session ID to prevent fixation attacks
    public let sessionId: String?
    /// List of previously used sign-in methods
    public let signinMethods: [String]?
    
    // Deprecated fields
    @available(*, deprecated, message: "This field is deprecated")
    public let kind: String?
    @available(*, deprecated, message: "This field is deprecated")
    public let allProviders: [String]?
} 