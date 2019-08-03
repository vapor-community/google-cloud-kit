//
//  BucketAccessControlAPI.swift
//  GoogleCloudProvider
//
//  Created by Andrew Edwards on 5/19/18.
//

import Vapor

public protocol BucketAccessControlAPI {
    func delete(bucket: String, entity: String, queryParameters: [String: String]?) throws -> Future<EmptyResponse>
    func get(bucket: String, entity: String, queryParameters: [String: String]?) throws -> Future<BucketAccessControls>
    func create(bucket: String, entity: String, role: String, queryParameters: [String: String]?) throws -> Future<BucketAccessControls>
    func list(bucket: String, queryParameters: [String: String]?) throws -> Future<BucketAccessControlList>
    func patch(bucket: String, entity: String, queryParameters: [String: String]?) throws -> Future<BucketAccessControls>
    func update(bucket: String, entity: String, role: String?, queryParameters: [String: String]?) throws -> Future<BucketAccessControls>
}

extension BucketAccessControlAPI {
    public func delete(bucket: String, entity: String, queryParameters: [String: String]? = nil) throws -> Future<EmptyResponse> {
        return try delete(bucket: bucket, entity: entity, queryParameters: queryParameters)
    }
    
    public func get(bucket: String, entity: String, queryParameters: [String: String]? = nil) throws -> Future<BucketAccessControls> {
        return try get(bucket: bucket, entity: entity, queryParameters: queryParameters)
    }
    
    public func create(bucket: String, entity: String, role: String, queryParameters: [String: String]? = nil) throws -> Future<BucketAccessControls> {
        return try create(bucket: bucket, entity: entity, role: role, queryParameters: queryParameters)
    }
    
    public func list(bucket: String, queryParameters: [String: String]? = nil) throws -> Future<BucketAccessControlList> {
        return try list(bucket: bucket, queryParameters: queryParameters)
    }
    
    public func patch(bucket: String, entity: String, queryParameters: [String: String]? = nil) throws -> Future<BucketAccessControls> {
        return try patch(bucket: bucket, entity: entity, queryParameters: queryParameters)
    }
    
    public func update(bucket: String, entity: String, role: String? = nil, queryParameters: [String: String]? = nil) throws -> Future<BucketAccessControls> {
        return try update(bucket: bucket, entity: entity, role: role, queryParameters: queryParameters)
    }
}

public final class GoogleBucketAccessControlAPI: BucketAccessControlAPI {
    let endpoint = "https://www.googleapis.com/storage/v1/b"
    let request: GoogleCloudStorageRequest
    
    init(request: GoogleCloudStorageRequest) {
        self.request = request
    }
    
    /// Permanently deletes the ACL entry for the specified entity on the specified bucket.
    public func delete(bucket: String, entity: String, queryParameters: [String: String]?) throws -> Future<EmptyResponse> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try request.send(method: .DELETE, path: "\(endpoint)/\(bucket)/acl/\(entity)", query: queryParams)
    }
    
    /// Returns the ACL entry for the specified entity on the specified bucket.
    public func get(bucket: String, entity: String, queryParameters: [String: String]?) throws -> Future<BucketAccessControls> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try request.send(method: .GET, path: "\(endpoint)/\(bucket)/acl/\(entity)", query: queryParams)
    }
    
    /// Creates a new ACL entry on the specified bucket.
    public func create(bucket: String, entity: String, role: String, queryParameters: [String: String]?) throws -> Future<BucketAccessControls> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        let body = try JSONEncoder().encode(["entity": entity, "role": role]).convertToHTTPBody()
        
        return try request.send(method: .POST, path: "\(endpoint)/\(bucket)/acl", query: queryParams, body: body)
    }
    
    /// Retrieves ACL entries on a specified bucket.
    public func list(bucket: String, queryParameters: [String: String]?) throws -> Future<BucketAccessControlList> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try request.send(method: .GET, path: "\(endpoint)/\(bucket)/acl", query: queryParams)
    }
    
    /// Updates an ACL entry on the specified bucket. This method supports patch semantics.
    public func patch(bucket: String, entity: String, queryParameters: [String: String]?) throws -> Future<BucketAccessControls> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try request.send(method: .PATCH, path: "\(endpoint)/\(bucket)/acl/\(entity)", query: queryParams)
    }
    
    /// Updates an ACL entry on the specified bucket.
    public func update(bucket: String, entity: String, role: String?, queryParameters: [String: String]?) throws -> Future<BucketAccessControls> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        var body = ""
        
        if let role = role {
            body = try JSONEncoder().encode(["role": role]).convert(to: String.self)
        }
        
        return try request.send(method: .POST, path: "\(endpoint)/\(bucket)/acl/\(entity)", query: queryParams, body: body.convertToHTTPBody())
    }
}
