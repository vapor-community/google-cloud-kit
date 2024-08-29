import Core

public struct AllocateIdsRequest: GoogleCloudModel {
    public init(
        keys: [Key]? = nil,
        databaseId: String? = nil
    ) {
        self.databaseId = databaseId
        self.keys = keys
    }
    /// The ID of the database against which to make the request.
    /// '(default)' is not allowed; please use empty string '' to refer the default database.
    public let databaseId: String?
    /// A list of keys with incomplete key paths for which to allocate IDs. No key may be reserved/read-only.
    public let keys: [Key]?
}
