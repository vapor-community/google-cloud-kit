import Core

public struct AllocateIdsRequest: GoogleCloudModel {
    public init(keys: [Key]? = nil) {
        self.keys = keys
    }
    /// A list of keys with incomppublic lete key paths for which to allocate IDs. No key may be reserved/read-only.
    public let keys: [Key]?
}
