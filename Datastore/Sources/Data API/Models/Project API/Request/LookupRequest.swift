import Core

public struct LookupRequest: GoogleCloudModel {
    public init(keys: [Key]? = nil,
                 readOptions: ReadOptions? = nil) {
        self.keys = keys
        self.readOptions = readOptions
    }
    /// Keys of entities to look up.
    public let keys: [Key]?
    /// The options for this lookup request.
    public let readOptions: ReadOptions?
}

