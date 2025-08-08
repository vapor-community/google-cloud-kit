import Core
import Foundation

public struct FederatedUserIdentifier: GoogleCloudModel {
    /// The ID of the provider, such as "google.com" for Google and "facebook.com" for Facebook
    public let providerId: String
    /// The unique ID of the user for the specified provider
    public let rawId: String
    
    public init(providerId: String, rawId: String) {
        self.providerId = providerId
        self.rawId = rawId
    }
} 