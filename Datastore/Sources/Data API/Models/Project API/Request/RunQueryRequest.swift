import Core

public struct RunQueryRequest: GoogleCloudModel {
    
    public init(
        gqlQuery: GqlQuery? = nil,
        partitionId: PartitionId? = nil,
        query: Query? = nil,
        readOptions: ReadOptions? = nil
    ) {
        self.gqlQuery = gqlQuery
        self.partitionId = partitionId
        self.query = query
        self.readOptions = readOptions
    }
    
    /// The GQL query to run.
    public let gqlQuery: GqlQuery?
    /// Entities are partitioned into subsets, identified by a partition ID. Queries are scoped to a single partition. This partition ID is normalized with the standard default context partition ID.
    public let partitionId: PartitionId?
    /// The query to run.
    public let query: Query?
    /// The options for this query.
    public let readOptions: ReadOptions?
}

