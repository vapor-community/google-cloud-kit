import Core

public struct RollbackRequest: GoogleCloudModel {
    
    public init(
        transaction: String,
        databaseId: String? = nil
    ) {
        self.transaction = transaction
        self.databaseId = databaseId
    }
    
    /// The transaction identifier,
    public let transaction: String
    /// The ID of the database against which to make the request.
    /// '(default)' is not allowed; please use empty string '' to refer the default database.
    public let databaseId: String?
}
