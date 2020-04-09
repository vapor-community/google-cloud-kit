import Core

public struct LookupResponse: GoogleCloudModel {
    public init(deferred: [Key]? = nil, found: [EntityResult]? = nil, missing: [EntityResult]? = nil) {
        self.deferred = deferred
        self.found = found
        self.missing = missing
    }
    /// A list of keys that were not looked up due to resource constraints. The order of results in this field is undefined and has no relation to the order of the keys in the input.
    public let deferred: [Key]?
    /// Entities found as ResultType.FULL entities. The order of results in this field is undefined and has no relation to the order of the keys in the input.
    public let found: [EntityResult]?
    /// Entities not found as ResultType.KEY_ONLY entities. The order of results in this field is undefined and has no relation to the order of the keys in the input.
    public let missing: [EntityResult]?
}
