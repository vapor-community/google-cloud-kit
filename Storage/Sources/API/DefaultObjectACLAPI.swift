//
//  DefaultObjectACLAPI.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 5/20/18.
//

import NIO
import NIOHTTP1
import Foundation

public protocol DefaultObjectACLAPI {
    
    /// Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/defaultObjectAccessControls/delete#parameters)
    func delete(bucket: String, entity: String, queryParameters: [String: String]?) async throws -> EmptyResponse
    
    /// Returns the default object ACL entry for the specified entity on the specified bucket.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/defaultObjectAccessControls/get#parameters)
    func get(bucket: String, entity: String, queryParameters: [String: String]?) async throws -> ObjectAccessControls
    
    /// Creates a new default object ACL entry on the specified bucket.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter entity: The entity holding the permission.
    /// - Parameter role: The access permission for the entity.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/defaultObjectAccessControls/insert#parameters)
    func insert(bucket: String, entity: String, role: String, queryParameters: [String: String]?) async throws -> ObjectAccessControls
    
    /// Retrieves default object ACL entries on the specified bucket.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/defaultObjectAccessControls/list#parameters)
    func list(bucket: String, queryParameters: [String: String]?) async throws -> ObjectAccessControlsList
    
    /// Updates a default object ACL entry on the specified bucket. This method supports patch semantics.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/defaultObjectAccessControls/patch#parameters)
    func patch(bucket: String, entity: String, queryParameters: [String: String]?) async throws -> ObjectAccessControls
    
    /// Updates a default object ACL entry on the specified bucket.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
    /// - Parameter defaultAccessControl: Default access controls resource.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/defaultObjectAccessControls/update#parameters)
    func update(bucket: String, entity: String, defaultAccessControl: [String: Any], queryParameters: [String: String]?) async throws -> ObjectAccessControls
}

extension DefaultObjectACLAPI {
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
    ) async throws -> ObjectAccessControls {
        try await get(bucket: bucket, entity: entity, queryParameters: queryParameters)
    }
    
    public func insert(
        bucket: String,
        entity: String,
        role: String,
        queryParameters: [String: String]? = nil
    ) async throws -> ObjectAccessControls {
        try await insert(bucket: bucket, entity: entity, role: role, queryParameters: queryParameters)
    }
    
    public func list(
        bucket: String,
        queryParameters: [String: String]? = nil
    ) async throws -> ObjectAccessControlsList {
        try await list(bucket: bucket, queryParameters: queryParameters)
    }
    
    public func patch(
        bucket: String,
        entity: String,
        queryParameters: [String: String]? = nil
    ) async throws -> ObjectAccessControls {
        try await patch(bucket: bucket, entity: entity, queryParameters: queryParameters)
    }
    
    public func update(
        bucket: String,
        entity: String,
        defaultAccessControl: [String: Any],
        queryParameters: [String: String]? = nil
    ) async throws -> ObjectAccessControls {
        try await update(bucket: bucket, entity: entity, defaultAccessControl: defaultAccessControl, queryParameters: queryParameters)
    }
}

public final class GoogleCloudStorageDefaultObjectACLAPI: DefaultObjectACLAPI {
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
        
        return try await request.send(method: .DELETE, path: "\(endpoint)/\(bucket)/defaultObjectAcl/\(entity)", query: queryParams)
    }
    
    public func get(
        bucket: String,
        entity: String,
        queryParameters: [String: String]?
    ) async throws -> ObjectAccessControls {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try await request.send(method: .GET, path: "\(endpoint)/\(bucket)/defaultObjectAcl/\(entity)", query: queryParams)
    }
    
    public func insert(
        bucket: String,
        entity: String,
        role: String,
        queryParameters: [String: String]?
    ) async throws -> ObjectAccessControls {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        let body: [String: Any] = ["entity": entity, "role": role]
        let requestBody = try JSONSerialization.data(withJSONObject: body)
        return try await request.send(method: .POST, path: "\(endpoint)/\(bucket)/defaultObjectAcl", query: queryParams, body: .bytes(.init(data: requestBody)))
    }
    
    public func list(
        bucket: String,
        queryParameters: [String: String]?
    ) async throws -> ObjectAccessControlsList {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try await request.send(method: .GET, path: "\(endpoint)/\(bucket)/defaultObjectAcl", query: queryParams)
    }

    public func patch(
        bucket: String,
        entity: String,
        queryParameters: [String: String]?
    ) async throws -> ObjectAccessControls {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try await request.send(method: .PATCH, path: "\(endpoint)/\(bucket)/defaultObjectAcl/\(entity)", query: queryParams)
    }
    
    public func update(
        bucket: String,
        entity: String,
        defaultAccessControl: [String: Any],
        queryParameters: [String: String]?
    ) async throws -> ObjectAccessControls {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        let requestBody = try JSONSerialization.data(withJSONObject: defaultAccessControl)
        return try await request.send(method: .PUT, path: "\(endpoint)/\(bucket)/defaultObjectAcl/\(entity)", query: queryParams, body: .bytes(.init(data: requestBody)))
    }
}
