import Core

public struct BeginTransactionRequest: GoogleCloudModel {
    public init(
        transactionOptions: TransactionOptions? = nil,
        databaseId: String? = nil
    ) {
        self.transactionOptions = transactionOptions
        self.databaseId = databaseId
    }
    /// Options for a new transaction.
    public let transactionOptions: TransactionOptions?
    /// The ID of the database against which to make the request.
    /// '(default)' is not allowed; please use empty string '' to refer the default database.
    public let databaseId: String?
}
