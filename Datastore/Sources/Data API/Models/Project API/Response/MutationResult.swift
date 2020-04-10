import Core

public struct MutationResult: GoogleCloudModel {
    public init(conflictDetected: Bool? = false, key: Key? = nil, version: String) {
        self.conflictDetected = conflictDetected
        self.key = key
        self.version = version
    }
    /// Whether a conflict was detected for this mutation. Always false when a conflict detection strategy field is not set in the mutation.
    public let conflictDetected: Bool?
    /// The automatically allocated key. Set only when the mutation allocated a key.
    public let key: Key?
    /// The version of the entity on the server after processing the mutation. If the mutation doesn't change anything on the server, then the version will be the version of the current entity or, if no entity is present, a version that is strictly greater than the version of any previous entity and less than the version of any possible future entity.
    public let version: String
}
