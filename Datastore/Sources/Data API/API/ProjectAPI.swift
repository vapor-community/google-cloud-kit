import AsyncHTTPClient
import NIO
import Foundation

public protocol DatastoreProjectAPI {
    
    /// Allocates IDs for the given keys, which is useful for referencing an entity before it is inserted
    /// - Parameters:
    ///   - keys: A list of keys with incomplete key paths for which to allocate IDs. No key may be reserved/read-only.
    ///   - databaseId: The ID of the database against which to make the request. `nil` or an empty string refers to the default database.
    func allocateIDs(keys: [Key], databaseId: String?) -> EventLoopFuture<AllocateIdsResponse>
    
    /// Prevents the supplied keys' IDs from being auto-allocated by Cloud Datastore.
    /// - Parameters:
    ///   - databaseId: If not empty, the ID of the database against which to make the request.
    ///   - keys: A list of keys with complete key paths whose numeric IDs should not be auto-allocated.
    func reserveIDs(databaseId: String?, keys: [Key]) -> EventLoopFuture<EmptyResponse>
    
    /// Begins a new transaction.
    /// - Parameters:
    ///   - transactionOptions: Options for a new transaction.
    ///   - databaseId: The ID of the database against which to make the request. `nil` or an empty string refers to the default database.
    func beginTransaction(transactionOptions: TransactionOptions, databaseId: String?) -> EventLoopFuture<BeginTransactionResponse>
       
    /// Commits a transaction, optionally creating, deleting or modifying some entities.
    /// - Parameters:
    ///   - mode: The type of commit to perform.
    ///   - mutations: The mutations to perform.
    ///   - databaseId: The ID of the database against which to make the request. `nil` or an empty string refers to the default database.
    func commit(mode: CommitRequest.Mode, mutations: [CommitRequest.Mutation], databaseId: String?) -> EventLoopFuture<CommitResponse>
    
    /// Looks up entities by key.
    /// - Parameter keys: Keys of entities to look up.
    ///   - databaseId: The ID of the database against which to make the request. `nil` or an empty string refers to the default database.
    func lookup(keys: [Key], databaseId: String?) -> EventLoopFuture<LookupResponse>
    
    /// Rolls back a transaction.
    /// - Parameter transactionId: The transaction identifier, returned by a call to beginTransaction(transactionOptions:).
    ///   - databaseId: The ID of the database against which to make the request.
    func rollback(transactionId: String, databaseId: String?) -> EventLoopFuture<EmptyResponse>
    
    /// Queries for entities.
    /// - Parameters:
    ///   - partitionId: The (optional) namespace and partition against which to run the query
    ///   - readOptions: The options for this query.
    ///   - datastoreQuery: A query to run, either of normal or GQL type
    ///   - databaseId: The ID of the database against which to make the request. `nil` or an empty string refers to the default database.
    func runQuery(partitionId: PartitionId, readOptions: ReadOptions?, datastoreQuery: DatastoreQuery, databaseId: String?) -> EventLoopFuture<RunQueryResponse>
    
    /// Runs a query and performs an aggregation (sum, count or average) on the results
    /// - Parameters:
    ///   - query: The query to run
    ///   - aggregations: The aggregations to perform on the results of the given query
    ///   - partitionId: The (optional) namespace and partition against which to run the query
    ///   - readOptions: The options for this query
    ///   - databaseId: The ID of the database against which to make the request. `nil` or an empty string refers to the default database.
    func runAggregationQuery(query: Query, aggregations: [Aggregation], partitionId: PartitionId, readOptions: ReadOptions?, databaseId: String?) -> EventLoopFuture<RunAggregationQueryResponse>
    
    /// Runs an aggregation query in GQL format
    /// - Parameters:
    ///   - gqlQuery: The aggregation query to run in GQL format
    ///   - partitionId: The namespace and partition against which to run the query
    ///   - readOptions: The options for this query
    ///   - databaseId: The ID of the database against which to make the request. `nil` or an empty string refers to the default database.
    func runAggregationQuery(gqlQuery: GqlQuery, partitionId: PartitionId, readOptions: ReadOptions?, databaseId: String?) -> EventLoopFuture<RunAggregationQueryResponse>
    
    /// Inserts an entity
    /// Convenience method equivalent to calling `commit(mode:mutations:)` with a single insert mutation
    /// - Parameters:
    ///   - entity: The entity to insert
    ///   - databaseId: The ID of the database against which to make the request. `nil` or an empty string refers to the default database.
    func insert(_ entity: Entity, databaseId: String?) -> EventLoopFuture<CommitResponse>
    
    /// Inserts multiple entities
    /// Convenience method equivalent to calling `commit(mode:mutations:)` with multiple insert mutations
    /// - Parameters:
    ///   - entity: The entities to insert
    ///   - databaseId: The ID of the database against which to make the request. `nil` or an empty string refers to the default database.
    func insert(_ entities: [Entity], databaseId: String?) -> EventLoopFuture<CommitResponse>
    
    /// Updates an entity
    /// Convenience method equivalent to calling `commit(mode:mutations:)` with a single update mutation
    /// - Parameters:
    ///   - entity: The entities to update
    ///   - databaseId: The ID of the database against which to make the request. `nil` or an empty string refers to the default database.
    func update(_ entity: Entity, databaseId: String?) -> EventLoopFuture<CommitResponse>
    
    /// Updates multiple entities
    /// Convenience method equivalent to calling `commit(mode:mutations:)` with multiple update mutations
    /// - Parameters:
    ///   - entity: The entities to update
    ///   - databaseId: The ID of the database against which to make the request. `nil` or an empty string refers to the default database.
    func update(_ entities: [Entity], databaseId: String?) -> EventLoopFuture<CommitResponse>
    
    /// Upserts (update-or-insert) an entity
    /// Convenience method equivalent to calling `commit(mode:mutations:)` with a single upsert mutation
    /// - Parameters:
    ///   - entity: The entity to upsert
    ///   - databaseId: The ID of the database against which to make the request. `nil` or an empty string refers to the default database.
    func upsert(_ entity: Entity, databaseId: String?) -> EventLoopFuture<CommitResponse>
    
    /// Upserts multiple entities
    /// Convenience method equivalent to calling `commit(mode:mutations:)` with multiple upsert mutations
    /// - Parameters:
    ///   - entity: The entities to upsert
    ///   - databaseId: The ID of the database against which to make the request. `nil` or an empty string refers to the default database.
    func upsert(_ entities: [Entity], databaseId: String?) -> EventLoopFuture<CommitResponse>
    
    /// Deletes an entity
    /// Convenience method equivalent to calling `commit(mode:mutations:)` with a single delete mutation
    /// - Parameters:
    ///   - key: The key of the entity to delete
    ///   - databaseId: The ID of the database against which to make the request. `nil` or an empty string refers to the default database.
   func delete(_ key: Key, databaseId: String?) -> EventLoopFuture<CommitResponse>
    
    /// Deletes multiple entities
    /// Convenience method equivalent to calling `commit(mode:mutations:)` with multiple delete mutations
    /// - Parameters:
    ///   - key: The keys of the entities to delete
    ///   - databaseId: The ID of the database against which to make the request. `nil` or an empty string refers to the default database.
    func delete(_ keys: [Key], databaseId: String?) -> EventLoopFuture<CommitResponse>
}

extension DatastoreProjectAPI {
    
    public func allocateIDs(keys: [Key], databaseId: String? = nil) -> EventLoopFuture<AllocateIdsResponse> {
        return allocateIDs(keys: keys, databaseId: databaseId)
    }
    
    public func reserveIDs(databaseId: String? = nil, keys: [Key]) -> EventLoopFuture<EmptyResponse> {
        return reserveIDs(databaseId: databaseId, keys: keys)
    }
    
    public func beginTransaction(transactionOptions: TransactionOptions = .init(), databaseId: String? = nil) -> EventLoopFuture<BeginTransactionResponse> {
        return beginTransaction(transactionOptions: transactionOptions, databaseId: databaseId)
    }
    
    public func commit(mode: CommitRequest.Mode = .nonTransactional, mutations: [CommitRequest.Mutation], databaseId: String? = nil) -> EventLoopFuture<CommitResponse> {
        return commit(mode: mode, mutations: mutations, databaseId: databaseId)
    }
    
    public func lookup(keys: [Key], databaseId: String? = nil) -> EventLoopFuture<LookupResponse> {
        return lookup(keys: keys, databaseId: databaseId)
    }
    
    public func rollback(transactionId: String, databaseId: String? = nil) -> EventLoopFuture<EmptyResponse> {
        return rollback(transactionId: transactionId, databaseId: databaseId)
    }
   
    public func runQuery(partitionId: PartitionId, readOptions: ReadOptions? = nil, datastoreQuery: DatastoreQuery, databaseId: String? = nil) -> EventLoopFuture<RunQueryResponse> {
        return runQuery(partitionId: partitionId, readOptions: readOptions, datastoreQuery: datastoreQuery, databaseId: databaseId)
    }
    
    public func runAggregationQuery(query: Query, aggregations: [Aggregation], partitionId: PartitionId, readOptions: ReadOptions? = nil, databaseId: String? = nil) -> EventLoopFuture<RunAggregationQueryResponse> {
        return runAggregationQuery(query: query, aggregations: aggregations, partitionId: partitionId, readOptions: readOptions, databaseId: databaseId)
    }
    
    public func runAggregationQuery(gqlQuery: GqlQuery, partitionId: PartitionId, readOptions: ReadOptions? = nil, databaseId: String? = nil) -> EventLoopFuture<RunAggregationQueryResponse> {
        return runAggregationQuery(gqlQuery: gqlQuery, partitionId: partitionId, readOptions: readOptions, databaseId: databaseId)
    }
    
    public func insert(_ entity: Entity, databaseId: String? = nil) -> EventLoopFuture<CommitResponse> {
        return insert([entity], databaseId: databaseId)
    }
    
    public func insert(_ entities: [Entity], databaseId: String? = nil) -> EventLoopFuture<CommitResponse> {
        return insert(entities, databaseId: databaseId)
    }
    
    public func update(_ entity: Entity, databaseId: String? = nil) -> EventLoopFuture<CommitResponse> {
        return update(entity, databaseId: databaseId)
    }
    
    public func update(_ entities: [Entity], databaseId: String? = nil) -> EventLoopFuture<CommitResponse> {
        return update(entities, databaseId: databaseId)
    }
    
    public func upsert(_ entity: Entity, databaseId: String? = nil) -> EventLoopFuture<CommitResponse> {
        return upsert(entity, databaseId: databaseId)
    }
    
    public func upsert(_ entities: [Entity], databaseId: String? = nil) -> EventLoopFuture<CommitResponse> {
        return upsert(entities, databaseId: databaseId)
    }
    
    public func delete(_ key: Key, databaseId: String? = nil) -> EventLoopFuture<CommitResponse> {
        return delete(key, databaseId: databaseId)
    }
    
    public func delete(_ keys: [Key], databaseId: String? = nil) -> EventLoopFuture<CommitResponse> {
        return delete(keys, databaseId: databaseId)
    }
}

public final class GoogleCloudDatastoreProjectAPI: DatastoreProjectAPI {
    
    let endpoint: String
    let request: GoogleCloudDatastoreRequest
    let encoder = JSONEncoder()
    
    init(
        request: GoogleCloudDatastoreRequest,
        endpoint: String
    ) {
        self.request = request
        self.endpoint = endpoint
    }
    
    private var projectPath: String {
        "\(endpoint)/v1/projects/\(request.project)"
    }
    
    public func allocateIDs(
        keys: [Key],
        databaseId: String? = nil
    ) -> EventLoopFuture<AllocateIdsResponse> {
        
        do {
            let allocateIdsRequest = AllocateIdsRequest(
                keys: keys,
                databaseId: databaseId
            )
            let body = try HTTPClient.Body.data(encoder.encode(allocateIdsRequest))
            return request.send(method: .POST, path: "\(projectPath):allocateIds", body: body)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func reserveIDs(
        databaseId: String? = nil,
        keys: [Key]
    ) -> EventLoopFuture<EmptyResponse> {
        
        do {
            let reserveIdsRequest = ReserveIdsRequest(
                databaseId: databaseId,
                keys: keys
            )
            let body = try HTTPClient.Body.data(encoder.encode(reserveIdsRequest))
            return request.send(method: .POST, path: "\(projectPath):reserveIds", body: body)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func beginTransaction(
        transactionOptions: TransactionOptions = .init(),
        databaseId: String? = nil
    ) -> EventLoopFuture<BeginTransactionResponse> {

        do {
            let transactionRequest = BeginTransactionRequest(
                transactionOptions: transactionOptions,
                databaseId: databaseId
            )
            let body = try HTTPClient.Body.data(encoder.encode(transactionRequest))
            return request.send(method: .POST, path: "\(projectPath):beginTransaction", body: body)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func commit(
        mode: CommitRequest.Mode = .nonTransactional,
        mutations: [CommitRequest.Mutation],
        databaseId: String? = nil
    ) -> EventLoopFuture<CommitResponse> {
        
        do {
            let commitRequest = CommitRequest(
                mode: mode,
                mutations: mutations,
                databaseId: databaseId
            )
            let body = try HTTPClient.Body.data(encoder.encode(commitRequest))
            return request.send(method: .POST, path: "\(projectPath):commit", body: body)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }

    public func lookup(
        keys: [Key],
        databaseId: String? = nil
    ) -> EventLoopFuture<LookupResponse> {

        do {
            let lookupRequest = LookupRequest(
                keys: keys,
                databaseId: databaseId
            )
            let body = try HTTPClient.Body.data(encoder.encode(lookupRequest))
            return request.send(method: .POST, path: "\(projectPath):lookup", body: body)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func rollback(
        transactionId: String,
        databaseId: String? = nil
    ) -> EventLoopFuture<EmptyResponse> {
        
        do {
            let rollbackRequest = RollbackRequest(
                transaction: transactionId,
                databaseId: databaseId
            )
            let body = try HTTPClient.Body.data(encoder.encode(rollbackRequest))
            return request.send(method: .POST, path: "\(projectPath):rollback", body: body)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func runQuery(
        partitionId: PartitionId,
        readOptions: ReadOptions? = nil,
        datastoreQuery: DatastoreQuery,
        databaseId: String? = nil
    ) -> EventLoopFuture<RunQueryResponse> {
        
        do {
            let runQueryRequest: RunQueryRequest
            
            switch datastoreQuery {
            case .query(let query):
                runQueryRequest = RunQueryRequest(
                    gqlQuery: nil,
                    partitionId: partitionId,
                    query: query,
                    readOptions: readOptions,
                    databaseId: databaseId
                )
            case .gqlQuery(let query):
                runQueryRequest = RunQueryRequest(
                    gqlQuery: query,
                    partitionId: partitionId,
                    query: nil,
                    readOptions: readOptions,
                    databaseId: databaseId
                )
            }
            
            let body = try HTTPClient.Body.data(encoder.encode(runQueryRequest))
            return request.send(method: .POST, path: "\(projectPath):runQuery", body: body)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func runAggregationQuery(
        query: Query,
        aggregations: [Aggregation],
        partitionId: PartitionId,
        readOptions: ReadOptions? = nil,
        databaseId: String? = nil
    ) -> EventLoopFuture<RunAggregationQueryResponse> {
        
        let queryRequest = RunAggregationQueryRequest(
            query: query,
            aggregations: aggregations,
            partitionId: partitionId,
            readOptions: readOptions,
            databaseId: databaseId
        )
        
        do {
            let body = try HTTPClient.Body.data(encoder.encode(queryRequest))
            return request.send(
                method: .POST,
                path: "\(projectPath):runAggregationQuery",
                body: body
            )
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func runAggregationQuery(
        gqlQuery: GqlQuery,
        partitionId: PartitionId,
        readOptions: ReadOptions? = nil,
        databaseId: String = ""
    ) -> EventLoopFuture<RunAggregationQueryResponse> {
        
        let queryRequest = RunAggregationQueryRequest(
            gqlQuery: gqlQuery,
            partitionId: partitionId,
            readOptions: readOptions,
            databaseId: databaseId
        )
        
        do {
            let body = try HTTPClient.Body.data(encoder.encode(queryRequest))
            return request.send(
                method: .POST,
                path: "\(projectPath):runAggregationQuery",
                body: body
            )
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func insert(
        _ entity: Entity,
        databaseId: String? = nil
    ) -> EventLoopFuture<CommitResponse> {
        return insert(
            [entity],
            databaseId: databaseId
        )
    }
    
    public func insert(
        _ entities: [Entity],
        databaseId: String? = nil
    ) -> EventLoopFuture<CommitResponse> {
        let mutations = entities.map { CommitRequest.Mutation(.insert($0)) }
        return commit(
            mutations: mutations,
            databaseId: databaseId
        )
    }
    
    public func update(
        _ entity: Entity,
        databaseId: String? = nil
    ) -> EventLoopFuture<CommitResponse> {
        return update(
            [entity],
            databaseId: databaseId
        )
    }
    
    public func update(
        _ entities: [Entity],
        databaseId: String? = nil
    ) -> EventLoopFuture<CommitResponse> {
        let mutations = entities.map { CommitRequest.Mutation(.update($0)) }
        return commit(
            mutations: mutations,
            databaseId: databaseId
        )
    }
    
    public func upsert(
        _ entity: Entity,
        databaseId: String? = nil
    ) -> EventLoopFuture<CommitResponse> {
        return upsert(
            [entity],
            databaseId: databaseId
        )
    }
    
    public func upsert(
        _ entities: [Entity],
        databaseId: String? = nil
    ) -> EventLoopFuture<CommitResponse> {
        let mutations = entities.map { CommitRequest.Mutation(.upsert($0)) }
        return commit(
            mutations: mutations,
            databaseId: databaseId
        )
    }
    
    public func delete(
        _ key: Key,
        databaseId: String? = nil
    ) -> EventLoopFuture<CommitResponse> {
        return delete(
            [key],
            databaseId: databaseId
        )
    }
    
    public func delete(
        _ keys: [Key],
        databaseId: String? = nil
    ) -> EventLoopFuture<CommitResponse> {
        let mutations = keys.map { CommitRequest.Mutation(.delete($0)) }
        return commit(
            mutations: mutations,
            databaseId: databaseId
        )
    }
}
