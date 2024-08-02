import Core

public struct RunAggregationQueryResponse: GoogleCloudModel {
    /// A batch of query results (always present).
    public let batch: AggregationResultBatch
    /// The parsed form of the GqlQuery from the request, if it was set.
    public let query: AggregationQuery?
    public let transaction: String?
}

public struct AggregationResultBatch: Codable {
    public let aggregationResults: [AggregationResult]
}

public struct AggregationResult: Codable {
    public let aggregateProperties: AggregateProperties
}

public typealias AggregateProperties = [String: Value]

