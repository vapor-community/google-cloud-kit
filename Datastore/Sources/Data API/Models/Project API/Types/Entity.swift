import Core
import Foundation

public typealias EntityProperties = [String: Value]

/// A Datastore data object.
/// An entity is limited to 1 megabyte when stored. That roughly corresponds to a limit of 1 megabyte for the serialized form of this message.
public struct Entity: GoogleCloudModel {
    
    /// The entity's key.
    /// An entity must have a key, unless otherwise documented (for example, an entity in Value.entity_value may have no key). An entity's kind is its key path's last element's kind, or null if it has no key.
    public let key: Key
    /// The entity's properties. The map's keys are property names. A property name matching regex __.*__ is reserved. A reserved property name is forbidden in certain documented contexts. The name must not contain more than 500 characters. The name cannot be "".
    public let properties: EntityProperties
    
    public init(key: Key, properties: EntityProperties) {
        self.key = key
        self.properties = properties
    }
}

public struct EntityResult: GoogleCloudModel {
    public let cursor: String
    public let entity: Entity
    public let version: String
}
