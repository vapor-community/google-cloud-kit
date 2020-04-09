import Core
import Foundation

/// A partition ID identifies a grouping of entities. The grouping is always by project and namespace, however the namespace ID may be empty.
public struct PartitionId: GoogleCloudModel {
    
    /// If not empty, the ID of the namespace to which the entities belong.
    public let namespaceId: String?
    /// The ID of the project to which the entities belong.
    public let projectId: String
    
    public init(namespaceId: String? = nil, projectId: String) {
        self.namespaceId = namespaceId
        self.projectId = projectId
    }
}
