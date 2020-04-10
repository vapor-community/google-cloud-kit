//
//  ObjectACLAPI.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 5/20/18.
//

import NIO
import NIOHTTP1
import Foundation

public protocol ObjectAccessControlsAPI {
    
    /// Permanently deletes the ACL entry for the specified entity on the specified object.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
    /// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/objectAccessControls/delete#parameters)
    func delete(bucket: String,
                entity: String,
                object: String,
                queryParameters: [String: String]?) -> EventLoopFuture<EmptyResponse>
    
    /// Returns the ACL entry for the specified entity on the specified object.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
    /// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/objectAccessControls/get#parameters)
    func get(bucket: String, entity: String, object: String, queryParameters: [String: String]?) -> EventLoopFuture<ObjectAccessControls>
    
    /// Creates a new ACL entry on the specified object.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
    /// - Parameter entity: The entity holding the permission.
    /// - Parameter role: The access permission for the entity.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/objectAccessControls/insert#parameters)
    func insert(bucket: String,
                object: String,
                entity: String,
                role: String,
                queryParameters: [String: String]?) -> EventLoopFuture<ObjectAccessControls>
    
    /// Retrieves ACL entries on the specified object.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/objectAccessControls/list#parameters)
    func list(bucket: String, object: String, queryParameters: [String: String]?) -> EventLoopFuture<ObjectAccessControlsList>
    
    /// Updates an ACL entry on the specified object. This method supports patch semantics.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter object: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
    /// - Parameter entity: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
    /// - Parameter objectACL: The relevant portions of the ObjectAccessControl resource.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/objectAccessControls/patch#parameters)
    func patch(bucket: String,
               object: String,
               entity: String,
               objectACL: [String: Any],
               queryParameters: [String: String]?) -> EventLoopFuture<ObjectAccessControls>
    
    /// Updates an ACL entry on the specified object.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
    /// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
    /// - Parameter objectACL: An ObjectAccessControls resource.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/objectAccessControls/update#parameters)
    func update(bucket: String,
                object: String,
                entity: String,
                objectACL: [String: Any],
                queryParameters: [String: String]?) -> EventLoopFuture<ObjectAccessControls>
}

extension ObjectAccessControlsAPI {
    public func delete(bucket: String,
                       entity: String,
                       object: String,
                       queryParameters: [String: String]? = nil) -> EventLoopFuture<EmptyResponse> {
        return delete(bucket: bucket, entity: entity, object: object, queryParameters: queryParameters)
    }
    
    public func get(bucket: String, entity: String, object: String, queryParameters: [String: String]? = nil) -> EventLoopFuture<ObjectAccessControls> {
        return get(bucket: bucket, entity: entity, object: object, queryParameters: queryParameters)
    }
    
    public func insert(bucket: String,
                       object: String,
                       entity: String,
                       role: String,
                       queryParameters: [String: String]? = nil) -> EventLoopFuture<ObjectAccessControls> {
        return insert(bucket: bucket,
                      object: object,
                      entity: entity,
                      role: role,
                      queryParameters: queryParameters)
    }
    
    public func list(bucket: String, object: String, queryParameters: [String: String]? = nil) -> EventLoopFuture<ObjectAccessControlsList> {
        return list(bucket: bucket, object: object, queryParameters: queryParameters)
    }
    
    public func patch(bucket: String,
                      object: String,
                      entity: String,
                      objectACL: [String: Any],
                      queryParameters: [String: String]?) -> EventLoopFuture<ObjectAccessControls> {
        return patch(bucket: bucket, object: object, entity: entity, objectACL: objectACL, queryParameters: queryParameters)
    }
    
    public func update(bucket: String,
                       object: String,
                       entity: String,
                       objectACL: [String: Any],
                       queryParameters: [String: String]? = nil) -> EventLoopFuture<ObjectAccessControls> {
        return update(bucket: bucket, object: object, entity: entity, objectACL: objectACL, queryParameters: queryParameters)
    }
}

public final class GoogleCloudStorageObjectAccessControlsAPI: ObjectAccessControlsAPI {
    let endpoint = "https://www.googleapis.com/storage/v1/b"
    let request: GoogleCloudStorageRequest
    
    init(request: GoogleCloudStorageRequest) {
        self.request = request
    }
    
    public func delete(bucket: String,
                       entity: String,
                       object: String,
                       queryParameters: [String: String]?) -> EventLoopFuture<EmptyResponse> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return request.send(method: .DELETE, path: "\(endpoint)/\(bucket)/o/\(object)/acl/\(entity)", query: queryParams)
    }
    
    public func get(bucket: String, entity: String, object: String, queryParameters: [String: String]?) -> EventLoopFuture<ObjectAccessControls> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return request.send(method: .GET, path: "\(endpoint)/\(bucket)/o/\(object)acl/\(entity)", query: queryParams)
    }
    
    public func insert(bucket: String,
                       object: String,
                       entity: String,
                       role: String,
                       queryParameters: [String: String]?) -> EventLoopFuture<ObjectAccessControls> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        do {
            let body: [String: Any] = ["entity": entity, "role": role]
            let requestBody = try JSONSerialization.data(withJSONObject: body)
            return request.send(method: .POST, path: "\(endpoint)/\(bucket)/o/\(object)/acl", query: queryParams, body: .data(requestBody))
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func list(bucket: String, object: String, queryParameters: [String: String]?) -> EventLoopFuture<ObjectAccessControlsList> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return request.send(method: .GET, path: "\(endpoint)/\(bucket)/o/\(object)/acl", query: queryParams)
    }
    
    public func patch(bucket: String,
                      object: String,
                      entity: String,
                      objectACL: [String: Any],
                      queryParameters: [String: String]?) -> EventLoopFuture<ObjectAccessControls> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: objectACL)
            return request.send(method: .PATCH, path: "\(endpoint)/\(bucket)/o/\(object)/acl/\(entity)", query: queryParams, body: .data(requestBody))
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func update(bucket: String,
                       object: String,
                       entity: String,
                       objectACL: [String: Any],
                       queryParameters: [String: String]?) -> EventLoopFuture<ObjectAccessControls> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: objectACL)
            return request.send(method: .PUT, path: "\(endpoint)/\(bucket)/o/\(object)/acl/\(entity)", query: queryParams, body: .data(requestBody))
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
}
