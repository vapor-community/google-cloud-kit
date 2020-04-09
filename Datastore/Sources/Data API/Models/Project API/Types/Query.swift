import Core

public enum DatastoreQuery {
    case query(Query)
    case gqlQuery(GqlQuery)
}

public struct Query: GoogleCloudModel {
    
    /// The properties to make distinct. The query results will contain the first result for each distinct combination of values for the given properties (if empty, all results are returned).
    public let distinctOn: [PropertyReference]?
    /// An ending point for the query results. Query cursors are returned in query result batches and can only be used to limit the same query.
    public let endCursor: String?
    /// The filter to apply.
    public let filter: Filter?
    /// The kinds to query (if empty, returns entities of all kinds). Currently at most 1 kind may be specified.
    public let kind: [KindExpression]?
    /// The maximum number of results to return. Applies after all other constraints. Optional. Unspecified is interpreted as no limit. Must be >= 0 if specified.
    public let limit: Int?
    /// The number of results to skip. Applies before limit, but after all other constraints. Optional. Must be >= 0 if specified.
    public let offset: Int?
    /// The order to apply to the query results (if empty, order is unspecified).
    public let order: [PropertyOrder]?
    /// The projection to return. Defaults to returning all properties.
    public let projection: [Projection]?
    /// A starting point for the query results. Query cursors are returned in query result batches and can only be used to continue the same query.
    public let startCursor: String?
    
    public init(distinctOn: [PropertyReference]? = nil,
        endCursor: String? = nil,
        filter: Filter.TypedFilter? = nil,
        kind: [KindExpression]? = nil,
        limit: Int? = nil,
        offset: Int? = nil,
        order: [PropertyOrder]? = nil,
        projection: [Projection]? = nil,
        startCursor: String? = nil) {
        
        switch filter {
        case .composite(let filter):
            self.filter = Filter(compositeFilter: filter)
        case .property(let filter):
            self.filter = Filter(propertyFilter: filter)
        case .none:
            self.filter = nil
        }
        self.distinctOn = distinctOn
        self.endCursor = endCursor
        
        self.kind = kind
        self.limit = limit
        self.offset = offset
        self.order = order
        self.projection = projection
        self.startCursor = startCursor
    }
    
    init(distinctOn: [PropertyReference]? = nil,
                 endCursor: String? = nil,
                 filter: Filter? = nil,
                 kind: [KindExpression]? = nil,
                 limit: Int? = nil,
                 offset: Int? = nil,
                 order: [PropertyOrder]? = nil,
                 projection: [Projection]? = nil,
                 startCursor: String? = nil) {
        self.distinctOn = distinctOn
        self.endCursor = endCursor
        self.filter = filter
        self.kind = kind
        self.limit = limit
        self.offset = offset
        self.order = order
        self.projection = projection
        self.startCursor = startCursor
    }
}

/// A filter that merges multiple other filters using the given operator.
public struct CompositeFilter: GoogleCloudModel {
    
    /// The list of filters to combine. Must contain at least one filter.
    public let filters: [Filter]
    /// The operator for combining multiple filters.
    public let op: Operator?
    
    /// A composite filter operator.
    public enum Operator: String, RawRepresentable, GoogleCloudModel {
        /// The results are required to satisfy each of the combined filters.
        case and = "AND"
    }
       
    public init(_ filters: [Filter]) {
        self.init(filters: filters, op: .and)
    }
    
    init(filters: [Filter],
                 op: Operator? = nil) {
        self.filters = filters
        self.op = op
    }
}

/// A filter on a specific property.
public struct PropertyFilter: GoogleCloudModel {

    /// The operator to filter by.
    public let op: Operator?
    /// The property to filter by.
    public let property: PropertyReference?
    /// The value to compare the property to.
    public let value: Value?
    
    public enum Operator: String, RawRepresentable, GoogleCloudModel {
        case lessThan = "LESS_THAN"
        case lessThanOrEqual = "LESS_THAN_OR_EQUAL"
        case greaterThan = "GREATER_THAN"
        case greaterThanOrEqual = "GREATER_THAN_OR_EQUAL"
        case equal = "EQUAL"
        case hasAncestor = "HAS_ANCESTOR"
    }
    
    public init(op: Operator? = nil,
                 property: PropertyReference? = nil,
                 value: Value? = nil) {
        self.op = op
        self.property = property
        self.value = value
    }
}

/// A representation of a property in a projection.
public struct Projection: GoogleCloudModel {
    
    /// The property to project.
    public let property: PropertyReference
    
    public init(property: PropertyReference) {
        self.property = property
    }
}

public struct PropertyOrder: GoogleCloudModel {
    
    /// The direction to order by.
    public let direction: Direction
    /// The property to order by.
    public let property: PropertyReference
    
    public enum Direction: String, RawRepresentable, GoogleCloudModel {
        case ascending = "ASCENDING"
        case descending = "DESCENDING"
    }
    
    public init(direction: Direction = .ascending,
                 property: PropertyReference) {
        self.direction = direction
        self.property = property
    }
}

/// A representation of a kind.
public struct KindExpression: GoogleCloudModel {
    
    /// The name of the kind.
    public let name: String
    
    public init(_ name: String) {
        self.name = name
    }
}

/// A reference to a property relative to the kind expressions.
public struct PropertyReference: GoogleCloudModel {
    
    /// The name of the property. If name includes "."s, it may be interpreted as a property name path.
    public let name: String
    
    public init(_ name: String) {
        self.name = name
    }
}

/// A holder for any type of filter.
public struct Filter: GoogleCloudModel {
    
    public enum TypedFilter {
        case composite(CompositeFilter)
        case property(PropertyFilter)
    }
    
    /// A composite filter.
    public let compositeFilter: CompositeFilter?
    /// A filter on a property.
    public let propertyFilter: PropertyFilter?
    
    public init(_ typedFilter: TypedFilter) {
        switch typedFilter {
        case .composite(let filter):
            self.init(compositeFilter: filter, propertyFilter: nil); return
        case .property(let filter):
            self.init(compositeFilter: nil, propertyFilter: filter); return
        }
    }
    
    init(compositeFilter: CompositeFilter? = nil,
                 propertyFilter: PropertyFilter? = nil) {
        self.compositeFilter = compositeFilter
        self.propertyFilter = propertyFilter
    }
}

public struct QueryResultBatch: GoogleCloudModel {
    
    /// A cursor that points to the position after the last result in the batch.
    public let endCursor: String?
    /// The result type for every entity in entityResults.
    public let entityResultType: ResultType?
    /// The results for this batch.
    public let entityResults: [EntityResult]?
    /// The state of the query after the current batch.
    public let moreResults: MoreResultsType?
    /// A cursor that points to the position after the last skipped result. Will be set when skippedResults != 0.
    public let skippedCursor: String?
    /// The number of results skipped, typically because of an offset.
    public let skippedResults: Int?
    /// The version number of the snapshot this batch was returned from. This applies to the range of results from the query's startCursor (or the beginning of the query if no cursor was given) to this batch's endCursor (not the query's endCursor).
    /// In a single transaction, subsequent query result batches for the same query can have a greater snapshot version number. Each batch's snapshot version is valid for all preceding batches. The value will be zero for eventually consistent queries.
    public let snapshotVersion: String?
    
    public enum ResultType: String, RawRepresentable, GoogleCloudModel {
        /// The key and properties.
        case full = "FULL"
        /// A projected subset of properties. The entity may have no key.
        case projection = "PROJECTION"
        /// Only the key.
        case keyOnly = "KEY_ONLY"
    }
    
    public enum MoreResultsType: String, RawRepresentable, GoogleCloudModel {
        /// There may be additional batches to fetch from this query.
        case notFinished = "NOT_FINISHED"
        /// The query is finished, but there may be more results after the limit.
        case moreResultsAfterLimit = "MORE_RESULTS_AFTER_LIMIT"
        /// The query is finished, but there may be more results after the end cursor.
        case moreResultsAfterCursor = "MORE_RESULTS_AFTER_CURSOR"
        /// The query is finished, and there are no more results.
        case noMoreReults = "NO_MORE_RESULTS"
    }
    
    public init(endCursor: String? = nil,
                 entityResultType: ResultType? = nil,
                 entityResults: [EntityResult]? = nil,
                 moreResults: MoreResultsType? = nil,
                 skippedCursor: String? = nil,
                 skippedResults: Int? = nil,
                 snapshotVersion: String? = nil) {
        self.endCursor = endCursor
        self.entityResultType = entityResultType
        self.entityResults = entityResults
        self.moreResults = moreResults
        self.skippedCursor = skippedCursor
        self.skippedResults = skippedResults
        self.snapshotVersion = snapshotVersion
    }
}

public struct GqlQuery: GoogleCloudModel {
    
    /// When false, the query string must not contain any literals and instead must bind all values. For example, SELECT * FROM Kind WHERE a = 'string literal' is not allowed, while SELECT * FROM Kind WHERE a = @value is.
    public let allowLiterals: Bool?
    /// For each non-reserved named binding site in the query string, there must be a named parameter with that name, but not necessarily the inverse.
    /// Key must match regex [A-Za-z_$][A-Za-z_$0-9]*, must not match regex __.*__, and must not be "".
    /// An object containing a list of "key": value pairs. Example: { "name": "wrench", "mass": "1.3kg", "count": "3" }.
    public let namedBindings: GqlQueryNamedBindings?
    /// Numbered binding site @1 references the first numbered parameter, effectively using 1-based indexing, rather than the usual 0.
    /// For each binding site numbered i in queryString, there must be an i-th numbered parameter. The inverse must also be true.
    public let positionalBindings: [GqlQueryParameter]?
    /// A string of the format described [here](https://cloud.google.com/datastore/docs/reference/gql_reference).
    public let queryString: String?
    
    public init(allowLiterals: Bool? = nil,
                 namedBindings: GqlQueryNamedBindings? = nil,
                 positionalBindings: [GqlQueryParameter]? = nil,
                 queryString: String? = nil) {
        self.allowLiterals = allowLiterals
        self.namedBindings = namedBindings
        self.positionalBindings = positionalBindings
        self.queryString = queryString
    }
}

public typealias GqlQueryNamedBindings = [String: GqlQueryParameter]

public struct GqlQueryParameter: GoogleCloudModel {
    
    public enum TypedGqlQueryParameter {
        case value(Value)
        case cursor(String)
    }
    
    /// A query cursor. Query cursors are returned in query result batches.
    public let cursor: String?
    /// A value parameter.
    public let value: Value?
    
    public init(_ gqlQueryParameter: TypedGqlQueryParameter) {
        switch gqlQueryParameter {
        case .value(let value):
            self.init(value: value)
        case .cursor(let string):
            self.init(cursor: string)
        }
    }
    
    init(cursor: String? = nil,
                 value: Value? = nil) {
        self.cursor = cursor
        self.value = value
    }
}
