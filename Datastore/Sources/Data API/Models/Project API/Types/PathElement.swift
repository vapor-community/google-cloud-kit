import Core
import Foundation

/// A (kind, ID/name) pair used to construct a key path.
/// If either name or ID is set, the element is complete. If neither is set, the element is incomplete.
public struct PathElement: GoogleCloudModel {
    
    public enum PathElementIdentifier {
        case id(String)
        case name(String)
        case none
    }
    
    /// The auto-allocated ID of the entity. Never equal to zero. Values less than zero are discouraged and may not be supported in the future.
    public let id: String?
    /// The kind of the entity. A kind matching regex __.*__ is reserved/read-only. A kind must not contain more than 1500 bytes when UTF-8 encoded. Cannot be "".
    public let kind: String
    /// The name of the entity. A name matching regex __.*__ is reserved/read-only. A name must not be more than 1500 bytes when UTF-8 encoded. Cannot be "".
    public let name: String?
    
    public init(_ pathElementIdentifier: PathElementIdentifier, kind: String) {
        switch pathElementIdentifier {
        case .id(let string):
            self.init(id: string, kind: kind)
        case .name(let string):
            self.init(kind: kind, name: string)
        case .none:
            self.init(kind: kind)
        }
    }
    
    init(id: String? = nil, kind: String, name: String? = nil) {
        self.id = id
        self.kind = kind
        self.name = name
    }
}
