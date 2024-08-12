import Core

struct RunAggregationQueryRequest: GoogleCloudModel {
    
    init(
        gqlQuery: GqlQuery,
        partitionId: PartitionId? = nil,
        readOptions: ReadOptions? = nil,
        databaseId: String? = nil
    ) {
        self.gqlQuery = gqlQuery
        self.aggregationQuery = nil
        self.partitionId = partitionId
        self.readOptions = readOptions
        self.databaseId = databaseId
    }
    
    init(
        query: Query,
        aggregations: [Aggregation],
        partitionId: PartitionId? = nil,
        readOptions: ReadOptions? = nil,
        databaseId: String? = nil
    ) {
        self.aggregationQuery = AggregationQuery(aggregations: aggregations, nestedQuery: query)
        self.gqlQuery = nil
        self.partitionId = partitionId
        self.readOptions = readOptions
        self.databaseId = databaseId
    }
    
    /// The GQL query to run.
    let gqlQuery: GqlQuery?
    /// The aggregation query to run.
    let aggregationQuery: AggregationQuery?
    /// The (optional) namespace and partition against which to run the query
    let partitionId: PartitionId?
    /// The options for this query.
    let readOptions: ReadOptions?
    /// The ID of the database against which to make the request.
    /// '(default)' is not allowed; please use empty string '' to refer the default database.
    let databaseId: String?
}

