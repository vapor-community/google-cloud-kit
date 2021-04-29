import Core
import Foundation

public struct SecretPayload: GoogleCloudModel {
 
    public let data: String
    
    public var decodedData: String? {
        
        guard let base64EncodedData = Data(base64Encoded: data) else { return nil }
        
        return String(data: base64EncodedData, encoding: .utf8)
    }
}
