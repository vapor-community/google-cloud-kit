import Core

public struct Key: GoogleCloudModel {
    /// Entities are partitioned into subsets, currently identified by a project ID and namespace ID. Queries are scoped to a single partition.
    public let partitionId: PartitionId
    /// The entity path. An entity path consists of one or more elements composed of a kind and a string or numerical identifier, which identify entities. The first element identifies a root entity, the second element identifies a child of the root entity, the third element identifies a child of the second entity, and so forth. The entities identified by all prefixes of the path are called the element's ancestors.
    /// An entity path is always fully complete: all of the entity's ancestors are required to be in the path along with the entity identifier itself. The only exception is that in some documented cases, the identifier in the last path element (for the entity) itself may be omitted. For example, the last path element of the key of Mutation.insert may have no identifier.
    /// A path can never be empty, and a path can have at most 100 elements.
    public let path: [PathElement]
    
    public init(partitionId: PartitionId, path: [PathElement]) {
        self.partitionId = partitionId
        self.path = path
    }
}
