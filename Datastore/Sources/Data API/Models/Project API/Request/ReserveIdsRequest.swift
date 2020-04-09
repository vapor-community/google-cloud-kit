import Core

public struct ReserveIdsRequest: GoogleCloudModel {
    public init(databaseId: String? = nil,
                 keys: [Key]) {
        self.databaseId = databaseId
        self.keys = keys
    }
    /// If not empty, the ID of the database against which to make the request.
    public let databaseId: String?
    /// A list of keys with comppublic lete key paths whose numeric IDs should not be auto-allocated.
    public let keys: [Key]
}
