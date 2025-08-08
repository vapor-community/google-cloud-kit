import Core
import Foundation

public struct SignInWithPhoneNumberResponse: GoogleCloudModel {
    /// Identity Platform ID token for the authenticated user
    public let idToken: String?
    /// Refresh token for the authenticated user
    public let refreshToken: String?
    /// The number of seconds until the ID token expires
    public let expiresIn: String?
    /// The id of the authenticated user
    public let localId: String?
    /// Whether the authenticated user was created by this request
    public let isNewUser: Bool?
    /// A proof of the phone number verification
    public let temporaryProof: String?
    /// Phone number of the authenticated user
    public let phoneNumber: String
    /// The number of seconds until the temporary proof expires
    public let temporaryProofExpiresIn: String?
    
    // Deprecated fields
    @available(*, deprecated, message: "This field is deprecated")
    public let verificationProof: String?
    @available(*, deprecated, message: "This field is deprecated")
    public let verificationProofExpiresIn: String?
} 