import Core
import Foundation

public struct SecretVersionData: Codable {
    /// The resource name of the SecretVersion in the format projects/*/secrets/*/versions/*.
    public let name: String
    /// Secret payload
    public let payload: SecretPayload
}

/// A secret payload resource in the Secret Manager API. This contains the sensitive secret payload that is associated with a SecretVersion.
public struct SecretPayload: Codable {
    /// The secret data. Must be no larger than 64KiB.
    ///
    /// A base64-encoded string.
    public let data: String
    
    public var decodedData: String? {
        guard let base64EncodedData = Data(base64Encoded: data) else { return nil }
        
        return String(data: base64EncodedData, encoding: .utf8)
    }
}
