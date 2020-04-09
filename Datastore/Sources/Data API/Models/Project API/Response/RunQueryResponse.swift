import Core
import Foundation

public struct RunQueryResponse: GoogleCloudModel {
    public init(batch: QueryResultBatch? = nil,
                 query: Query? = nil) {
        self.batch = batch
        self.query = query
    }
    /// A batch of query results (always present).
    public let batch: QueryResultBatch?
    /// The parsed form of the GqlQuery from the request, if it was set.
    public let query: Query?
}
