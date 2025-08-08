import Core
import Foundation

public struct IssueSamlResponseResponse: GoogleCloudModel {
    /// Signed SAMLResponse created for the Relying Party
    public let samlResponse: String
    /// The ACS endpoint which consumes the returned SAMLResponse
    public let acsEndpoint: String
    /// Generated RelayState
    public let relayState: String?
    /// Email of the user
    public let email: String
    /// First name of the user
    public let firstName: String
    /// Last name of the user
    public let lastName: String
    /// Whether the logged in user was created by this request
    public let isNewUser: Bool
} 