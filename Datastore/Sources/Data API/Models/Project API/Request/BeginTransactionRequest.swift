import Core

public struct BeginTransactionRequest: GoogleCloudModel {
    public init(transactionOptions: TransactionOptions? = nil) {
        self.transactionOptions = transactionOptions
    }
    /// Options for a new transaction.
    public let transactionOptions: TransactionOptions?
}
