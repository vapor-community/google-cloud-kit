public struct AggregationQuery: Codable {
    
    public let aggregations: [AggregationReference]
    public let nestedQuery: Query
    
    init(
        aggregations: [Aggregation],
        nestedQuery: Query
    ) {
        self.aggregations = aggregations.map(AggregationReference.init)
        self.nestedQuery = nestedQuery
    }
    
    public struct AggregationReference: Codable {
        
        public let alias: String?
        public let count: Count?
        public let sum: Sum?
        public let avg: Average?
        
        init(
            alias: String? = nil,
            count: Count? = nil,
            sum: Sum? = nil,
            avg: Average? = nil
        ) {
            self.alias = alias
            self.count = count
            self.sum = sum
            self.avg = avg
        }
        
        init(_ aggregration: Aggregation) {
            switch aggregration {
                case .count(alias: let alias, upTo: let upTo):
                    self.init(alias: alias, count: Count(upTo: upTo)); return
                case .sum(alias: let alias, property: let property):
                    self.init(alias: alias, sum: Sum(property: property)); return
                case .avg(alias: let alias, property: let property):
                    self.init(alias: alias, avg: Average(property: property)); return
            }
        }
        
        public struct Count: Codable {
            public let upTo: String?
        }
        
        public struct Sum: Codable {
            public let property: PropertyReference
        }
        
        public struct Average: Codable {
            public let property: PropertyReference
        }
    }
}

public enum Aggregation: Codable {
    case count(alias: String? = nil, upTo: String? = nil)
    case sum(alias: String? = nil, property: PropertyReference)
    case avg(alias: String? = nil, property: PropertyReference)
}
