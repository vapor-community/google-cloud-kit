import Core

public struct CommitRequest: GoogleCloudModel {
    
    public init(mode: Mode = .nonTransactional, mutations: [Mutation]) {
        self.mode = mode
        self.mutations = mutations
    }
    
    /// The type of commit to perform.
    public let mode: Mode
    /// The mutations to perform.
    /// When mode is TRANSACTIONAL, mutations affecting a single entity are applied in order. The following sequences of mutations affecting a single entity are not permitted in a single projects.commit request:
    /// - insert followed by insert
    /// - update followed by insert
    /// - upsert followed by insert
    /// - delete followed by update
    /// When mode is NON_TRANSACTIONAL, no two mutations may affect a single entity.
    public let mutations: [Mutation]
    /// The identifier of the transaction associated with the commit.
    private var transaction: String?
        
    /// The modes available for commits.
    public enum Mode: GoogleCloudModel {
        
        /// Transactional: The mutations are either all applied, or none are applied.
        /// The associated value is a transaction ID obtained from a call to beginTransaction()
        case transactional(String)
        /// Non-transactional: The mutations may not apply as all or none.
        case nonTransactional
        
        enum CodingKeys: String, CodingKey {
            case transactional
            case nonTransactional
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let stringValue = try container.decodeIfPresent(String.self, forKey: .transactional) {
                self = .transactional(stringValue)
            } else {
                self = .nonTransactional
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .transactional(let value):
                try container.encode(Mode.transactional(value), forKey: .transactional)
            case .nonTransactional:
                try container.encode(Mode.nonTransactional, forKey: .nonTransactional)
            }
        }
    }
    
    /// A mutation to apply to an entity.
    public struct Mutation: GoogleCloudModel {
        
        public enum TypedMutation {
            case insert(Entity)
            case update(Entity)
            case upsert(Entity)
            case delete(Key)
        }
        
        public init(_ typedMutation: TypedMutation, baseVersion: String? = nil) {
            switch typedMutation {
                
            case .insert(let entity):
                self.init(baseVersion: baseVersion, insert: entity)
            case .update(let entity):
                self.init(baseVersion: baseVersion, update: entity)
            case .upsert(let entity):
                self.init(baseVersion: baseVersion, upsert: entity)
            case .delete(let key):
                self.init(baseVersion: baseVersion, delete: key)
            }
        }
        
        init(baseVersion: String? = nil,
                     delete: Key? = nil,
                     insert: Entity? = nil,
                     update: Entity? = nil,
                     upsert: Entity? = nil) {
            self.baseVersion = baseVersion
            self.delete = delete
            self.insert = insert
            self.update = update
            self.upsert = upsert
        }
        /// The version of the entity that this mutation is being applied to. If this does not match the current version on the server, the mutation conflicts.
        public let baseVersion: String?
        /// The key of the entity to delete. The entity may or may not already exist. Must have a complete key path and must not be reserved/read-only.
        public let delete: Key?
        /// The entity to insert. The entity must not already exist. The entity key's final path element may be incomplete.
        public let insert: Entity?
        /// The entity to update. The entity must already exist. Must have a complete key path.
        public let update: Entity?
        /// The entity to upsert. The entity may or may not already exist. The entity key's final path element may be incomplete.
        public let upsert: Entity?
    }
    
    enum CodingKeys: String, CodingKey {
        case mode
        case mutations
        case transaction
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mutations, forKey: .mutations)
        
        switch mode {
        case .transactional(let value):
            try container.encode("TRANSACTIONAL", forKey: .mode)
            try container.encode(value, forKey: .transaction)
        case .nonTransactional:
            try container.encode("NON_TRANSACTIONAL", forKey: .mode)
            return
        }
    }
}
