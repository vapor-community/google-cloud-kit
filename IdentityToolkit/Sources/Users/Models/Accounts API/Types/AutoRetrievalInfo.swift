import Core
import Foundation

public struct AutoRetrievalInfo: GoogleCloudModel {
    /// The Android app's signature hash for Google Play Service's SMS Retriever API
    public let appSignatureHash: String
    
    public init(appSignatureHash: String) {
        self.appSignatureHash = appSignatureHash
    }
}