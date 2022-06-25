//
//  BucketAccessControlAPI.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 5/19/18.
//

import NIO
import NIOHTTP1
import Foundation

public protocol BucketAccessControlAPI {
    /// Permanently deletes the ACL e for the specified entity on the specified [bucket](https://cloud.google.com/storage/docs/json_api/v1/buckets).
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter entity: The entity holding the permission. Can be `user-userId`, `user-emailAddress`, `group-groupId`, `group-emailAddress`, `allUsers`, or `allAuthenticatedUsers`.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/bucketAccessControls/delete#parameters)
    func delete(bucket: String, entity: String, queryParameters: [String: String]?) async throws -> EmptyResponse
    
    /// Returns the ACL entry for the specified entity on the specified bucket.
    /// - Parameter bucket: Name of an existing bucket.
    /// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/bucketAccessControls/get#parameters)
    func get(bucket: String, entity: String, queryParameters: [String: String]?) async throws -> BucketAccessControls
    
    /// Creates a new ACL entry on the specified bucket.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter entity: The entity holding the permission
    /// - Parameter role: The access permission for the entity.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/bucketAccessControls/insert#parameters)
    func insert(bucket: String, entity: String, role: String, queryParameters: [String: String]?) async throws -> BucketAccessControls
    
    /// Retrieves ACL entries on a specified bucket.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/bucketAccessControls/list#parameters)
    func list(bucket: String, queryParameters: [String: String]?) async throws -> BucketAccessControlList
    
    /// Updates an ACL entry on the specified bucket. This method supports patch semantics.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/bucketAccessControls/patch#parameters)
    func patch(bucket: String, entity: String, queryParameters: [String: String]?) async throws -> BucketAccessControls
    
    /// Updates an ACL entry on the specified bucket.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
    /// - Parameter role: The access permission for the entity.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/bucketAccessControls/update#parameters)
    func update(bucket: String, entity: String, role: String?, queryParameters: [String: String]?) async throws -> BucketAccessControls
}

extension BucketAccessControlAPI {
    public func delete(
        bucket: String,
        entity: String,
        queryParameters: [String: String]? = nil
    ) async throws -> EmptyResponse {
        try await delete(bucket: bucket, entity: entity, queryParameters: queryParameters)
    }
    
    public func get(
        bucket: String,
        entity: String,
        queryParameters: [String: String]? = nil
    ) async throws -> BucketAccessControls {
        try await get(bucket: bucket, entity: entity, queryParameters: queryParameters)
    }
    
    public func insert(
        bucket: String,
        entity: String,
        role: String,
        queryParameters: [String: String]? = nil
    ) async throws -> BucketAccessControls {
        try await insert(bucket: bucket, entity: entity, role: role, queryParameters: queryParameters)
    }
    
    public func list(
        bucket: String,
        queryParameters: [String: String]? = nil
    ) async throws -> BucketAccessControlList {
        try await list(bucket: bucket, queryParameters: queryParameters)
    }
    
    public func patch(
        bucket: String,
        entity: String,
        queryParameters: [String: String]? = nil
    ) async throws -> BucketAccessControls {
        try await patch(bucket: bucket, entity: entity, queryParameters: queryParameters)
    }
    
    public func update(
        bucket: String,
        entity: String,
        role: String? = nil,
        queryParameters: [String: String]? = nil
    ) async throws -> BucketAccessControls {
        try await update(bucket: bucket, entity: entity, role: role, queryParameters: queryParameters)
    }
}

public final class GoogleCloudStorageBucketAccessControlAPI: BucketAccessControlAPI {
    let endpoint = "https://www.googleapis.com/storage/v1/b"
    let request: GoogleCloudStorageRequest
    
    init(request: GoogleCloudStorageRequest) {
        self.request = request
    }
    
    public func delete(
        bucket: String,
        entity: String,
        queryParameters: [String: String]?
    ) async throws -> EmptyResponse {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try await request.send(method: .DELETE, path: "\(endpoint)/\(bucket)/acl/\(entity)", query: queryParams)
    }
    
    public func get(
        bucket: String,
        entity: String,
        queryParameters: [String: String]?
    ) async throws -> BucketAccessControls {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try await request.send(method: .GET, path: "\(endpoint)/\(bucket)/acl/\(entity)", query: queryParams)
    }
    
    public func insert(
        bucket: String,
        entity: String,
        role: String,
        queryParameters: [String: String]?
    ) async throws -> BucketAccessControls {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }

        
        let body: [String: Any] = ["entity": entity, "role": role]
        
        let requestBody = try JSONSerialization.data(withJSONObject: body)
        return try await request.send(method: .POST, path: "\(endpoint)/\(bucket)/acl", query: queryParams, body: .bytes(.init(data: requestBody)))
    }
    
    public func list(
        bucket: String,
        queryParameters: [String: String]?
    ) async throws -> BucketAccessControlList {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try await request.send(method: .GET, path: "\(endpoint)/\(bucket)/acl", query: queryParams)
    }
    
    public func patch(
        bucket: String,
        entity: String,
        queryParameters: [String: String]?
    ) async throws -> BucketAccessControls {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try await request.send(method: .PATCH, path: "\(endpoint)/\(bucket)/acl/\(entity)", query: queryParams)
    }
    
    public func update(
        bucket: String,
        entity: String,
        role: String?,
        queryParameters: [String: String]?
    ) async throws -> BucketAccessControls {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        var body: [String: Any] = [:]
        if let role = role {
            body["role"] = role
        }
        
        let requestBody = try JSONSerialization.data(withJSONObject: body)
        return try await request.send(method: .POST, path: "\(endpoint)/\(bucket)/acl/\(entity)", query: queryParams, body: .bytes(.init(data: requestBody)))
    }
}
