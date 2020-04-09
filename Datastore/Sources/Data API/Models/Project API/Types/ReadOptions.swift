import Core
import Foundation

public struct ReadOptions: GoogleCloudModel {
    
    public enum TypedReadOptions {
        case readConsistency(ReadConsistency)
        case transaction(String)
    }
    /// The non-transactional read consistency to use. Cannot be set to STRONG for global queries.
    public let readConsistency: ReadConsistency?
    /// The identifier of the transaction in which to read.
    public let transaction: String?
    
    public init(_ typedReadOptions: TypedReadOptions) {
        switch typedReadOptions {
        case .readConsistency(let readConsistency):
            self.init(readConsistency: readConsistency)
        case .transaction(let transactionId):
            self.init(transaction: transactionId)
        }
    }
    
    init(readConsistency: ReadConsistency? = nil, transaction: String? = nil) {
        self.readConsistency = readConsistency
        self.transaction = transaction
    }
}

public enum ReadConsistency: String, RawRepresentable, GoogleCloudModel {
    case strong = "STRONG"
    case eventual = "EVENTUAL"
}
