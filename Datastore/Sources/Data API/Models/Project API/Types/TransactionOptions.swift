import Core

public struct TransactionOptions: GoogleCloudModel {
    
    public enum TypedTransactionOptions {
        case readOnly
        case readWrite(ReadWrite)
        case none
    }
    
    public let readOnly: ReadOnly?
    public let readWrite: ReadWrite?
    
    public init(_ transactionOptions: TypedTransactionOptions = .none) {
        switch transactionOptions {
        case .readOnly:
            self.init(readOnly: .init())
        case .readWrite(let options):
            self.init(readWrite: options)
        case .none:
            self.init(readOnly: nil, readWrite: nil)
        }
    }
    
    init(readOnly: ReadOnly? = nil, readWrite: ReadWrite? = nil) {
        self.readOnly = readOnly
        self.readWrite = readWrite
    }
}

public struct ReadOnly: GoogleCloudModel {}

public struct ReadWrite: GoogleCloudModel {
    public init(previousTransaction: String) {
        self.previousTransaction = previousTransaction
    }
    public let previousTransaction: String
}
