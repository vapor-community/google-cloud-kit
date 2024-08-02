import Core

struct RunAggregationQueryRequest: GoogleCloudModel {
    
    init(
        gqlQuery: GqlQuery,
        partitionId: PartitionId? = nil,
        readOptions: ReadOptions? = nil
    ) {
        self.gqlQuery = gqlQuery
        self.aggregationQuery = nil
        self.partitionId = partitionId
        self.readOptions = readOptions
    }
    
    init(
        query: Query,
        aggregations: [Aggregation],
        partitionId: PartitionId? = nil,
        readOptions: ReadOptions? = nil
    ) {
        self.aggregationQuery = AggregationQuery(aggregations: aggregations, nestedQuery: query)
        self.gqlQuery = nil
        self.partitionId = partitionId
        self.readOptions = readOptions
    }
    
    /// The GQL query to run.
    let gqlQuery: GqlQuery?
    /// The aggregation query to run.
    let aggregationQuery: AggregationQuery?
    /// The (optional) namespace and partition against which to run the query
    let partitionId: PartitionId?
    /// The options for this query.
    let readOptions: ReadOptions?
}

