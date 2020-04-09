import Core
import Foundation

public struct CommitResponse: GoogleCloudModel {
    /// The number of index entries updated during the commit, or zero if none were updated.
    public let indexUpdates: Int
    /// The result of performing the mutations. The i-th mutation result corresponds to the i-th mutation in the request.
    public let mutationResults: [MutationResult]
}
