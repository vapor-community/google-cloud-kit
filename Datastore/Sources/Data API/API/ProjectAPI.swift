import AsyncHTTPClient
import NIO
import Foundation

public protocol DatastoreProjectAPI {
    
    /// Allocates IDs for the given keys, which is useful for referencing an entity before it is inserted
    /// - Parameter keys: A list of keys with incomplete key paths for which to allocate IDs. No key may be reserved/read-only.
    func allocateIDs(keys: [Key]) -> EventLoopFuture<AllocateIdsResponse>
    
    /// Prevents the supplied keys' IDs from being auto-allocated by Cloud Datastore.
    /// - Parameters:
    ///   - databaseId: If not empty, the ID of the database against which to make the request.
    ///   - keys: A list of keys with complete key paths whose numeric IDs should not be auto-allocated.
    func reserveIDs(databaseId: String?, keys: [Key]) -> EventLoopFuture<EmptyResponse>
    
    /// Begins a new transaction.
    /// - Parameter transactionOptions: Options for a new transaction.
    func beginTransaction(transactionOptions: TransactionOptions) -> EventLoopFuture<BeginTransactionResponse>
       
    /// Commits a transaction, optionally creating, deleting or modifying some entities.
    /// - Parameters:
    ///   - mode: The type of commit to perform.
    ///   - mutations: The mutations to perform.
    func commit(mode: CommitRequest.Mode, mutations: [CommitRequest.Mutation]) -> EventLoopFuture<CommitResponse>
    
    /// Looks up entities by key.
    /// - Parameter keys: Keys of entities to look up.
    func lookup(keys: [Key]) -> EventLoopFuture<LookupResponse>
    
    /// Rolls back a transaction.
    /// - Parameter transactionId: The transaction identifier, returned by a call to beginTransaction(transactionOptions:).
    func rollback(transactionId: String) -> EventLoopFuture<EmptyResponse>
    
    /// Queries for entities.
    /// - Parameters:
    ///   - partitionId: Entities are partitioned into subsets, identified by a partition ID. Queries are scoped to a single partition. This partition ID is normalized with the standard default context partition ID.
    ///   - readOptions: The options for this query.
    ///   - datastoreQuery: A query to run, either of normal or GQL type
    func runQuery(partitionId: PartitionId, readOptions: ReadOptions?, datastoreQuery: DatastoreQuery) -> EventLoopFuture<RunQueryResponse>
    
    
    /// Inserts an entity
    /// Convenience method equivalent to calling `commit(mode:mutations:)` with a single insert mutation
    /// - Parameter entity: The entity to insert
    func insert(_ entity: Entity) -> EventLoopFuture<CommitResponse>
    
    /// Inserts multiple entities
    /// Convenience method equivalent to calling `commit(mode:mutations:)` with multiple insert mutations
    /// - Parameter entity: The entities to insert
    func insert(_ entities: [Entity]) -> EventLoopFuture<CommitResponse>
    
    /// Updates an entity
    /// Convenience method equivalent to calling `commit(mode:mutations:)` with a single update mutation
    /// - Parameter entity: The entities to update
    func update(_ entity: Entity) -> EventLoopFuture<CommitResponse>
    
    /// Updates multiple entities
    /// Convenience method equivalent to calling `commit(mode:mutations:)` with multiple update mutations
    /// - Parameter entity: The entities to update
    func update(_ entities: [Entity]) -> EventLoopFuture<CommitResponse>
    
    /// Upserts (update-or-insert) an entity
    /// Convenience method equivalent to calling `commit(mode:mutations:)` with a single upsert mutation
    /// - Parameter entity: The entity to upsert
    func upsert(_ entity: Entity) -> EventLoopFuture<CommitResponse>
    
    /// Upserts multiple entities
    /// Convenience method equivalent to calling `commit(mode:mutations:)` with multiple upsert mutations
    /// - Parameter entity: The entities to upsert
    func upsert(_ entities: [Entity]) -> EventLoopFuture<CommitResponse>
    
    /// Deletes an entity
    /// Convenience method equivalent to calling `commit(mode:mutations:)` with a single delete mutation
    /// - Parameter key: The key of the entity to delete
    func delete(_ key: Key) -> EventLoopFuture<CommitResponse>
    
    /// Deletes mutiple entities
    /// Convenience method equivalent to calling `commit(mode:mutations:)` with multiple delete mutations
    /// - Parameter key: The keys of the entities to delete
    func delete(_ keys: [Key]) -> EventLoopFuture<CommitResponse>
}

extension DatastoreProjectAPI {
    
    public func allocateIDs(keys: [Key]) -> EventLoopFuture<AllocateIdsResponse> {
        return allocateIDs(keys: keys)
    }
    
    func reserveIDs(databaseId: String? = nil, keys: [Key]) -> EventLoopFuture<EmptyResponse> {
        return reserveIDs(databaseId: databaseId, keys: keys)
    }
    
    public func beginTransaction(transactionOptions: TransactionOptions = .init()) -> EventLoopFuture<BeginTransactionResponse> {
        return beginTransaction(transactionOptions: transactionOptions)
    }
    
    public func commit(mode: CommitRequest.Mode = .nonTransactional, mutations: [CommitRequest.Mutation]) -> EventLoopFuture<CommitResponse> {
        return commit(mode: mode, mutations: mutations)
    }
    
    public func lookup(keys: [Key]) -> EventLoopFuture<LookupResponse> {
        return lookup(keys: keys)
    }
    
    public func rollback(transactionId: String) -> EventLoopFuture<EmptyResponse> {
        return rollback(transactionId: transactionId)
    }
   
    public func runQuery(partitionId: PartitionId, readOptions: ReadOptions? = nil, datastoreQuery: DatastoreQuery) -> EventLoopFuture<RunQueryResponse> {
        return runQuery(partitionId: partitionId, readOptions: readOptions, datastoreQuery: datastoreQuery)
    }
    
    public func insert(_ entity: Entity) -> EventLoopFuture<CommitResponse> {
        return insert([entity])
    }
    
    public func insert(_ entities: [Entity]) -> EventLoopFuture<CommitResponse> {
        return insert(entities)
    }
    
    public func update(_ entity: Entity) -> EventLoopFuture<CommitResponse> {
        return update(entity)
    }
    
    public func update(_ entities: [Entity]) -> EventLoopFuture<CommitResponse> {
        return update(entities)
    }
    
    public func upsert(_ entity: Entity) -> EventLoopFuture<CommitResponse> {
        return upsert(entity)
    }
    
    public func upsert(_ entities: [Entity]) -> EventLoopFuture<CommitResponse> {
        return upsert(entities)
    }
    
    public func delete(_ key: Key) -> EventLoopFuture<CommitResponse> {
        return delete(key)
    }
    
    public func delete(_ keys: [Key]) -> EventLoopFuture<CommitResponse> {
        return delete(keys)
    }
}

public final class GoogleCloudDatastoreProjectAPI: DatastoreProjectAPI {
    
    let endpoint: String
    let request: GoogleCloudDatastoreRequest
    let encoder = JSONEncoder()
    
    init(request: GoogleCloudDatastoreRequest,
         endpoint: String) {
        self.request = request
        self.endpoint = endpoint
    }
    
    private var projectPath: String {
        "\(endpoint)/v1/projects/\(request.project)"
    }
    
    public func allocateIDs(keys: [Key]) -> EventLoopFuture<AllocateIdsResponse> {
        
        do {
            let allocateIdsRequest = AllocateIdsRequest(keys: keys)
            let body = try HTTPClient.Body.data(encoder.encode(allocateIdsRequest))
            return request.send(method: .POST, path: "\(projectPath):allocateIds", body: body)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func reserveIDs(databaseId: String? = nil, keys: [Key]) -> EventLoopFuture<EmptyResponse> {
        
        do {
            let reserveIdsRequest = ReserveIdsRequest(databaseId: databaseId, keys: keys)
            
            let body = try HTTPClient.Body.data(encoder.encode(reserveIdsRequest))
            return request.send(method: .POST, path: "\(projectPath):reserveIds", body: body)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func beginTransaction(transactionOptions: TransactionOptions = .init()) -> EventLoopFuture<BeginTransactionResponse> {

        do {
            let body = try HTTPClient.Body.data(encoder.encode(transactionOptions))
            return request.send(method: .POST, path: "\(projectPath):beginTransaction", body: body)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func commit(mode: CommitRequest.Mode = .nonTransactional, mutations: [CommitRequest.Mutation]) -> EventLoopFuture<CommitResponse> {
        do {
            let commitRequest = CommitRequest(mode: mode, mutations: mutations)
            
            let body = try HTTPClient.Body.data(encoder.encode(commitRequest))
            return request.send(method: .POST, path: "\(projectPath):commit", body: body)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }

    
    public func lookup(keys: [Key]) -> EventLoopFuture<LookupResponse> {

        do {
            let lookupRequest = LookupRequest(keys: keys)
            let body = try HTTPClient.Body.data(encoder.encode(lookupRequest))
            return request.send(method: .POST, path: "\(projectPath):lookup", body: body)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func rollback(transactionId: String) -> EventLoopFuture<EmptyResponse> {
        
        do {
            let rollbackRequest = RollbackRequest(transaction: transactionId)
            let body = try HTTPClient.Body.data(encoder.encode(rollbackRequest))
            return request.send(method: .POST, path: "\(projectPath):rollback", body: body)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func runQuery(partitionId: PartitionId, readOptions: ReadOptions? = nil, datastoreQuery: DatastoreQuery) -> EventLoopFuture<RunQueryResponse> {
        
        do {
            var runQueryRequest = RunQueryRequest()
            
            switch datastoreQuery {
            case .query(let query):
                runQueryRequest = RunQueryRequest(gqlQuery: nil, partitionId: partitionId, query: query, readOptions: readOptions)
            case .gqlQuery(let query):
                runQueryRequest = RunQueryRequest(gqlQuery: query, partitionId: partitionId, query: nil, readOptions: readOptions)
            }
            
            let body = try HTTPClient.Body.data(encoder.encode(runQueryRequest))
            return request.send(method: .POST, path: "\(projectPath):runQuery", body: body)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func insert(_ entity: Entity) -> EventLoopFuture<CommitResponse> {
        return insert([entity])
    }
    
    public func insert(_ entities: [Entity]) -> EventLoopFuture<CommitResponse> {
        let mutations = entities.map { CommitRequest.Mutation(.insert($0)) }
        return commit(mutations: mutations)
    }
    
    public func update(_ entity: Entity) -> EventLoopFuture<CommitResponse> {
        return update([entity])
    }
    
    public func update(_ entities: [Entity]) -> EventLoopFuture<CommitResponse> {
        let mutations = entities.map { CommitRequest.Mutation(.update($0)) }
        return commit(mutations: mutations)
    }
    
    public func upsert(_ entity: Entity) -> EventLoopFuture<CommitResponse> {
        return upsert([entity])
    }
    
    public func upsert(_ entities: [Entity]) -> EventLoopFuture<CommitResponse> {
        let mutations = entities.map { CommitRequest.Mutation(.upsert($0)) }
        return commit(mutations: mutations)
    }
    
    public func delete(_ key: Key) -> EventLoopFuture<CommitResponse> {
        return delete([key])
    }
    
    public func delete(_ keys: [Key]) -> EventLoopFuture<CommitResponse> {
        let mutations = keys.map { CommitRequest.Mutation(.delete($0)) }
        return commit(mutations: mutations)
    }
}
