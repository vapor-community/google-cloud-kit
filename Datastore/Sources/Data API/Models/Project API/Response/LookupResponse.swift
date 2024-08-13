import Core

public struct LookupResponse: GoogleCloudModel {
    public init(
        deferred: [Key]? = nil,
        found: [EntityResult]? = nil,
        missing: [MissingEntityResult]? = nil
    ) {
        self.deferred = deferred
        self.found = found
        self.missing = missing
    }
    /// A list of keys that were not looked up due to resource constraints. The order of results in this field is undefined and has no relation to the order of the keys in the input.
    public let deferred: [Key]?
    /// Entities found as ResultType.FULL entities. The order of results in this field is undefined and has no relation to the order of the keys in the input.
    public let found: [EntityResult]?
    /// Entities not found as ResultType.KEY_ONLY entities. The order of results in this field is undefined and has no relation to the order of the keys in the input.
    public let missing: [MissingEntityResult]?
}

public struct MissingEntityResult: GoogleCloudModel {
    /// A KEY_ONLY entity
    public let entity: MissingEntity
    /// the version of the snapshot that was used to look up the entity
    public let version: String
    
    public struct MissingEntity: GoogleCloudModel {
        public let key: Key
    }
}
