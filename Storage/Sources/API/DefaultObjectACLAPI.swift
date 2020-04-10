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
    func delete(bucket: String, entity: String, queryParameters: [String: String]?) -> EventLoopFuture<EmptyResponse>
    
    /// Returns the default object ACL entry for the specified entity on the specified bucket.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/defaultObjectAccessControls/get#parameters)
    func get(bucket: String, entity: String, queryParameters: [String: String]?) -> EventLoopFuture<ObjectAccessControls>
    
    /// Creates a new default object ACL entry on the specified bucket.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter entity: The entity holding the permission.
    /// - Parameter role: The access permission for the entity.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/defaultObjectAccessControls/insert#parameters)
    func insert(bucket: String, entity: String, role: String, queryParameters: [String: String]?) -> EventLoopFuture<ObjectAccessControls>
    
    /// Retrieves default object ACL entries on the specified bucket.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/defaultObjectAccessControls/list#parameters)
    func list(bucket: String, queryParameters: [String: String]?) -> EventLoopFuture<ObjectAccessControlsList>
    
    /// Updates a default object ACL entry on the specified bucket. This method supports patch semantics.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/defaultObjectAccessControls/patch#parameters)
    func patch(bucket: String, entity: String, queryParameters: [String: String]?) -> EventLoopFuture<ObjectAccessControls>
    
    /// Updates a default object ACL entry on the specified bucket.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
    /// - Parameter defaultAccessControl: Default access controls resource.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/defaultObjectAccessControls/update#parameters)
    func update(bucket: String, entity: String, defaultAccessControl: [String: Any], queryParameters: [String: String]?) -> EventLoopFuture<ObjectAccessControls>
}

extension DefaultObjectACLAPI {
    public func delete(bucket: String, entity: String, queryParameters: [String: String]? = nil) -> EventLoopFuture<EmptyResponse> {
        return delete(bucket: bucket, entity: entity, queryParameters: queryParameters)
    }
    
    public func get(bucket: String, entity: String, queryParameters: [String: String]? = nil) -> EventLoopFuture<ObjectAccessControls> {
        return get(bucket: bucket, entity: entity, queryParameters: queryParameters)
    }
    
    public func insert(bucket: String, entity: String, role: String, queryParameters: [String: String]? = nil) -> EventLoopFuture<ObjectAccessControls> {
        return insert(bucket: bucket, entity: entity, role: role, queryParameters: queryParameters)
    }
    
    public func list(bucket: String, queryParameters: [String: String]? = nil) -> EventLoopFuture<ObjectAccessControlsList> {
        return list(bucket: bucket, queryParameters: queryParameters)
    }
    
    public func patch(bucket: String, entity: String, queryParameters: [String: String]? = nil) -> EventLoopFuture<ObjectAccessControls> {
        return patch(bucket: bucket, entity: entity, queryParameters: queryParameters)
    }
    
    public func update(bucket: String, entity: String, defaultAccessControl: [String: Any], queryParameters: [String: String]? = nil) -> EventLoopFuture<ObjectAccessControls> {
        return update(bucket: bucket, entity: entity, defaultAccessControl: defaultAccessControl, queryParameters: queryParameters)
    }
}

public final class GoogleCloudStorageDefaultObjectACLAPI: DefaultObjectACLAPI {
    let endpoint = "https://www.googleapis.com/storage/v1/b"
    let request: GoogleCloudStorageRequest
    
    init(request: GoogleCloudStorageRequest) {
        self.request = request
    }
    
    public func delete(bucket: String, entity: String, queryParameters: [String: String]?) -> EventLoopFuture<EmptyResponse> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return request.send(method: .DELETE, path: "\(endpoint)/\(bucket)/defaultObjectAcl/\(entity)", query: queryParams)
    }
    
    public func get(bucket: String, entity: String, queryParameters: [String: String]?) -> EventLoopFuture<ObjectAccessControls> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return request.send(method: .GET, path: "\(endpoint)/\(bucket)/defaultObjectAcl/\(entity)", query: queryParams)
    }
    
    public func insert(bucket: String, entity: String, role: String, queryParameters: [String: String]?) -> EventLoopFuture<ObjectAccessControls> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        do {
            let body: [String: Any] = ["entity": entity, "role": role]
            let requestBody = try JSONSerialization.data(withJSONObject: body)
            return request.send(method: .POST, path: "\(endpoint)/\(bucket)/defaultObjectAcl", query: queryParams, body: .data(requestBody))
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func list(bucket: String, queryParameters: [String: String]?) -> EventLoopFuture<ObjectAccessControlsList> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return request.send(method: .GET, path: "\(endpoint)/\(bucket)/defaultObjectAcl", query: queryParams)
    }

    public func patch(bucket: String, entity: String, queryParameters: [String: String]?) -> EventLoopFuture<ObjectAccessControls> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return request.send(method: .PATCH, path: "\(endpoint)/\(bucket)/defaultObjectAcl/\(entity)", query: queryParams)
    }
    
    public func update(bucket: String, entity: String, defaultAccessControl: [String: Any], queryParameters: [String: String]?) -> EventLoopFuture<ObjectAccessControls> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: defaultAccessControl)
            return request.send(method: .PUT, path: "\(endpoint)/\(bucket)/defaultObjectAcl/\(entity)", query: queryParams, body: .data(requestBody))
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
}
