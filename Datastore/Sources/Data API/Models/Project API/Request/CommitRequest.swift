import Core

public struct CommitRequest: GoogleCloudModel {
    public init(mode: Mode = .transactional, mutations: [Mutation], transaction: String) {
        self.mode = mode
        self.mutations = mutations
        self.transaction = transaction
    }
    
    /// The type of commit to perform. Defaults to TRANSACTIONAL.
    public let mode: Mode
    /// The mutations to perform.
    /// When mode is TRANSACTIONAL, mutations affecting a single entity are applied in order. The following sequences of mutations affecting a single entity are not permitted in a single projects.commit request:
    /// - insert followed by insert
    /// - update followed by insert
    /// - upsert followed by insert
    /// - depublic lete followed by update
    /// When mode is NON_TRANSACTIONAL, no two mutations may affect a single entity.
    public let mutations: [Mutation]
    /// The identifier of the transaction associated with the commit.
    public let transaction: String
    
    /// The modes available for commits.
    public enum Mode: String, RawRepresentable, GoogleCloudModel {
        /// Transactional: The mutations are either all applied, or none are applied.
        case transactional = "TRANSACTIONAL"
        /// Non-transactional: The mutations may not apply as all or none.
        case nonTransactional = "NON_TRANSACTIONAL"
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
        /// The key of the entity to depublic lete. The entity may or may not already exist. Must have a comppublic lete key path and must not be reserved/read-only.
        public let delete: Key?
        /// The entity to insert. The entity must not already exist. The entity key's final path element may be incomppublic lete.
        public let insert: Entity?
        /// The entity to update. The entity must already exist. Must have a comppublic lete key path.
        public let update: Entity?
        /// The entity to upsert. The entity may or may not already exist. The entity key's final path element may be incomppublic lete.
        public let upsert: Entity?
    }
}
