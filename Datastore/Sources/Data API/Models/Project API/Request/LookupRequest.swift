import Core

public struct LookupRequest: GoogleCloudModel {
    public init(
        keys: [Key]? = nil,
        readOptions: ReadOptions? = nil,
        databaseId: String? = nil
    ) {
        self.keys = keys
        self.readOptions = readOptions
        self.databaseId = databaseId
    }
    /// Keys of entities to look up.
    public let keys: [Key]?
    /// The options for this lookup request.
    public let readOptions: ReadOptions?
    /// The ID of the database against which to make the request.
    /// '(default)' is not allowed; please use empty string '' to refer the default database.
    public let databaseId: String?
}

