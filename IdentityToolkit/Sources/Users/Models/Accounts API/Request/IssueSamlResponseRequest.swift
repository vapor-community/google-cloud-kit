import Core
import Foundation

public struct IssueSamlResponseRequest: GoogleCloudModel {
    /// Relying Party identifier, which is the audience of issued SAMLResponse
    public let rpId: String
    /// The Identity Platform ID token
    public let idToken: String
    /// SAML app entity id specified in Google Admin Console
    public let samlAppEntityId: String?
    
    public init(
        rpId: String,
        idToken: String,
        samlAppEntityId: String? = nil
    ) {
        self.rpId = rpId
        self.idToken = idToken
        self.samlAppEntityId = samlAppEntityId
    }
} 