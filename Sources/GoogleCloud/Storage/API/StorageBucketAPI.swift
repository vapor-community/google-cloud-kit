//
//  StorageBucket.swift
//  GoogleCloudProvider
//
//  Created by Andrew Edwards on 4/17/18.
//

import Vapor

public protocol StorageBucketAPI {
    func delete(bucket: String, queryParameters: [String: String]?) throws -> Future<EmptyResponse>
    func get(bucket: String, queryParameters: [String: String]?) throws -> Future<GoogleStorageBucket>
    func getIAMPolicy(bucket: String, queryParameters: [String: String]?) throws -> Future<IAMPolicy>
    func create(queryParameters: [String: String]?, name: String, acl: [BucketAccessControls]?, billing: Billing?, cors: [Cors]?, defaultObjectAcl: [ObjectAccessControls]?, encryption: Encryption?, labels: [String: String]?, lifecycle: Lifecycle?, location: String?, logging: Logging?, storageClass: StorageClass?, versioning: Versioning?, website: Website?) throws -> Future<GoogleStorageBucket>
    func list(queryParameters: [String: String]?) throws -> Future<GoogleStorageBucketList>
    func patch(bucket: String, queryParameters: [String: String]?, acl: [BucketAccessControls]?, billing: Billing?, cors: [Cors]?, defaultObjectAcl: [ObjectAccessControls]?, encryption: Encryption?, labels: [String: String]?, lifecycle: Lifecycle?, logging: Logging?, versioning: Versioning?, website: Website?) throws -> Future<GoogleStorageBucket>
    func setIAMPolicy(bucket: String, iamPolicy: IAMPolicy, queryParameters: [String : String]?) throws -> Future<IAMPolicy>
    func testIAMPermissions(bucket: String, permissions: [String], queryParameters: [String : String]?) throws -> Future<Permission>
    func update(bucket: String, acl: [BucketAccessControls], queryParameters: [String: String]?, billing: Billing?, cors: [Cors]?, defaultObjectAcl: [ObjectAccessControls]?, encryption: Encryption?, labels: [String: String]?, lifecycle: Lifecycle?, logging: Logging?, storageClass: StorageClass?, versioning: Versioning?, website: Website?) throws -> Future<GoogleStorageBucket>
}

extension StorageBucketAPI {
    public func delete(bucket: String, queryParameters: [String: String]? = nil) throws -> Future<EmptyResponse> {
        return try delete(bucket: bucket, queryParameters: queryParameters)
    }
    
    public func get(bucket: String, queryParameters: [String: String]? = nil) throws -> Future<GoogleStorageBucket> {
        return try get(bucket: bucket, queryParameters: queryParameters)
    }
    
    public func getIAMPolicy(bucket: String, queryParameters: [String: String]? = nil) throws -> Future<IAMPolicy> {
        return try getIAMPolicy(bucket: bucket, queryParameters: queryParameters)
    }
    
    public func create( queryParameters: [String: String]? = nil,
                        name: String,
                        acl: [BucketAccessControls]? = nil,
                        billing: Billing? = nil,
                        cors: [Cors]? = nil,
                        defaultObjectAcl: [ObjectAccessControls]? = nil,
                        encryption: Encryption? = nil,
                        labels: [String: String]? = nil,
                        lifecycle: Lifecycle? = nil,
                        location: String? = nil,
                        logging: Logging? = nil,
                        storageClass: StorageClass? = nil,
                        versioning: Versioning? = nil,
                        website: Website? = nil) throws -> Future<GoogleStorageBucket> {
        return try create(queryParameters: queryParameters,
                          name: name,
                          acl: acl,
                          billing: billing,
                          cors: cors,
                          defaultObjectAcl: defaultObjectAcl,
                          encryption: encryption,
                          labels: labels,
                          lifecycle: lifecycle,
                          location: location,
                          logging: logging,
                          storageClass: storageClass,
                          versioning: versioning,
                          website: website)
    }
    
    public func list(queryParameters: [String: String]? = nil) throws -> Future<GoogleStorageBucketList> {
        return try list(queryParameters: queryParameters)
    }
    
    public func patch(bucket: String,
                      queryParameters: [String: String]? = nil,
                      acl: [BucketAccessControls]? = nil,
                      billing: Billing? = nil,
                      cors: [Cors]? = nil,
                      defaultObjectAcl: [ObjectAccessControls]? = nil,
                      encryption: Encryption? = nil,
                      labels: [String: String]? = nil,
                      lifecycle: Lifecycle? = nil,
                      logging: Logging? = nil,
                      versioning: Versioning? = nil,
                      website: Website? = nil) throws -> Future<GoogleStorageBucket> {
        return try patch(bucket: bucket,
                         queryParameters: queryParameters,
                         acl: acl,
                         billing: billing,
                         cors: cors,
                         defaultObjectAcl: defaultObjectAcl,
                         encryption: encryption,
                         labels: labels,
                         lifecycle: lifecycle,
                         logging: logging,
                         versioning: versioning,
                         website: website)
    }
    
    public func setIAMPolicy(bucket: String, iamPolicy: IAMPolicy, queryParameters: [String: String]? = nil) throws -> Future<IAMPolicy> {
        return try setIAMPolicy(bucket: bucket, iamPolicy: iamPolicy, queryParameters: queryParameters)
    }
    
    public func testIAMPermissions(bucket: String, permissions: [String], queryParameters: [String: String]? = nil) throws -> Future<Permission> {
        return try testIAMPermissions(bucket: bucket, permissions: permissions, queryParameters: queryParameters)
    }
    
    public func update(bucket: String,
                       acl: [BucketAccessControls],
                       queryParameters: [String: String]? = nil,
                       billing: Billing? = nil,
                       cors: [Cors]? = nil,
                       defaultObjectAcl: [ObjectAccessControls]? = nil,
                       encryption: Encryption? = nil,
                       labels: [String: String]? = nil,
                       lifecycle: Lifecycle? = nil,
                       logging: Logging? = nil,
                       storageClass: StorageClass? = nil,
                       versioning: Versioning? = nil,
                       website: Website? = nil) throws -> Future<GoogleStorageBucket> {
        return try update(bucket: bucket,
                          acl: acl,
                          queryParameters: queryParameters,
                          billing: billing,
                          cors: cors,
                          defaultObjectAcl: defaultObjectAcl,
                          encryption: encryption,
                          labels: labels,
                          lifecycle: lifecycle,
                          logging: logging,
                          storageClass: storageClass,
                          versioning: versioning,
                          website: website)
    }
}

public final class GoogleStorageBucketAPI: StorageBucketAPI {
    let endpoint = "https://www.googleapis.com/storage/v1/b"
    let request: GoogleCloudStorageRequest
    
    init(request: GoogleCloudStorageRequest) {
        self.request = request
    }

    /// Permanently deletes an empty bucket.
    public func delete(bucket: String, queryParameters: [String: String]?) throws -> Future<EmptyResponse> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try request.send(method: .DELETE, path: "\(endpoint)/\(bucket)", query: queryParams)
    }

    /// Returns metadata for the specified bucket.
    public func get(bucket: String, queryParameters: [String: String]?) throws -> Future<GoogleStorageBucket> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try request.send(method: .GET, path: "\(endpoint)/\(bucket)", query: queryParams)
    }

    /// Returns an IAM policy for the specified bucket.
    public func getIAMPolicy(bucket: String, queryParameters: [String: String]?) throws -> Future<IAMPolicy> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try request.send(method: .GET, path: "\(endpoint)/\(bucket)/iam", query: queryParams)
    }

    /// Creates a new bucket.
    public func create(queryParameters: [String: String]?,
                       name: String,
                       acl: [BucketAccessControls]?,
                       billing: Billing?,
                       cors: [Cors]?,
                       defaultObjectAcl: [ObjectAccessControls]?,
                       encryption: Encryption?,
                       labels: [String: String]?,
                       lifecycle: Lifecycle?,
                       location: String?,
                       logging: Logging?,
                       storageClass: StorageClass?,
                       versioning: Versioning?,
                       website: Website?) throws -> Future<GoogleStorageBucket> {
        var body: [String: Any] = ["name": name]
        var query = ""
        
        if var queryParameters = queryParameters {
            queryParameters["project"] = request.project
            query = queryParameters.queryParameters
        }
        else {
            query = "project=\(request.project)"
        }
        
        if let acl = acl {
            body["acl"] = try acl.map { try $0.toEncodedDictionary() }
        }
        
        if let billing = billing {
            body["billing"] = try billing.toEncodedDictionary()
        }
        
        if let cors = cors {
            body["cors"] = try cors.map { try $0.toEncodedDictionary() }
        }
        
        if let defaultObjectAcl = defaultObjectAcl {
            body["defaultObjectAcl"] = try defaultObjectAcl.map { try $0.toEncodedDictionary() }
        }
        
        if let encryption = encryption {
            body["encryption"] = try encryption.toEncodedDictionary()
        }
        
        if let labels = labels {
            body["labels"] = labels
        }
        
        if let lifecycle = lifecycle {
            body["lifecycle"] = try lifecycle.toEncodedDictionary()
        }
        
        if let location = location {
            body["location"] = location
        }
        
        if let logging = logging {
            body["logging"] = try logging.toEncodedDictionary()
        }
        
        if let storageClass = storageClass {
            body["storageClass"] = storageClass.rawValue
        }
        
        if let versioning = versioning {
            body["versioning"] = try versioning.toEncodedDictionary()
        }
        
        if let website = website {
            body["website"] = try website.toEncodedDictionary()
        }
        
        let requestBody = try JSONSerialization.data(withJSONObject: body).convertToHTTPBody()
        
        return try request.send(method: .POST, path: endpoint, query: query, body: requestBody)
    }

    /// Retrieves a list of buckets for a given project.
    public func list(queryParameters: [String: String]?) throws -> Future<GoogleStorageBucketList> {
        var query = ""
        
        if var queryParameters = queryParameters {
            queryParameters["project"] = request.project
            query = queryParameters.queryParameters
        }
        else {
            query = "project=\(request.project)"
        }
        
        return try request.send(method: .GET, path: endpoint, query: query)
    }

    /// Updates a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
    public func patch(bucket: String,
                      queryParameters: [String: String]?,
                      acl: [BucketAccessControls]?,
                      billing: Billing?,
                      cors: [Cors]?,
                      defaultObjectAcl: [ObjectAccessControls]?,
                      encryption: Encryption?,
                      labels: [String: String]?,
                      lifecycle: Lifecycle?,
                      logging: Logging?,
                      versioning: Versioning?,
                      website: Website?) throws -> Future<GoogleStorageBucket> {
        var body: [String: Any] = [:]
        var query = ""
        
        if let queryParameters = queryParameters {
            query = queryParameters.queryParameters
        }
        
        if let acl = acl {
            body["acl"] = try acl.map { try $0.toEncodedDictionary() }
        }
        
        if let billing = billing {
            body["billing"] = try billing.toEncodedDictionary()
        }
        
        if let cors = cors {
            body["cors"] = try cors.map { try $0.toEncodedDictionary() }
        }
        
        if let defaultObjectAcl = defaultObjectAcl {
            body["defaultObjectAcl"] = try defaultObjectAcl.map { try $0.toEncodedDictionary() }
        }
        
        if let encryption = encryption {
            body["encryption"] = try encryption.toEncodedDictionary()
        }
        
        if let labels = labels {
            body["labels"] = labels
        }
        
        if let lifecycle = lifecycle {
            body["lifecycle"] = try lifecycle.toEncodedDictionary()
        }
        
        if let logging = logging {
            body["logging"] = try logging.toEncodedDictionary()
        }
        
        if let versioning = versioning {
            body["versioning"] = try versioning.toEncodedDictionary()
        }
        
        if let website = website {
            body["website"] = try website.toEncodedDictionary()
        }
        
        let requestBody = try JSONSerialization.data(withJSONObject: body).convertToHTTPBody()
        
        return try request.send(method: .PATCH, path: endpoint, query: query, body: requestBody)
    }

    /// Updates an IAM policy for the specified bucket.
    public func setIAMPolicy(bucket: String, iamPolicy: IAMPolicy, queryParameters: [String: String]?) throws -> Future<IAMPolicy> {
        var query = ""
        
        if let queryParameters = queryParameters {
            query = queryParameters.queryParameters
        }

        let requestBody = try JSONSerialization.data(withJSONObject: try iamPolicy.toEncodedDictionary()).convertToHTTPBody()
        
        return try request.send(method: .PUT, path: "\(endpoint)/\(bucket)/iam", query: query, body: requestBody)
    }

    /// Tests a set of permissions on the given bucket to see which, if any, are held by the caller.
    public func testIAMPermissions(bucket: String, permissions: [String], queryParameters: [String: String]?) throws -> Future<Permission> {
        var query = ""
        
        if let queryParameters = queryParameters {
            query = queryParameters.queryParameters
            // if there are any permissions it's safe to add an ampersand to the end of the query we currently have.
            if permissions.count > 0 {
                query.append("&")
            }
        }
        
        let perms = permissions.map({ "permissions=\($0)" }).joined(separator: "&")
        
        query.append(perms)
        
        return try request.send(method: .GET, path: "\(endpoint)/\(bucket)/iam/testPermissions", query: query)
    }

    /// Updates a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate. This method sets the complete metadata of a bucket. If you want to change some of a bucket's metadata while leaving other parts unaffected, use the PATCH function instead.
    public func update(bucket: String,
                       acl: [BucketAccessControls],
                       queryParameters: [String: String]?,
                       billing: Billing?,
                       cors: [Cors]?,
                       defaultObjectAcl: [ObjectAccessControls]?,
                       encryption: Encryption?,
                       labels: [String: String]?,
                       lifecycle: Lifecycle?,
                       logging: Logging?,
                       storageClass: StorageClass?,
                       versioning: Versioning?,
                       website: Website?) throws -> Future<GoogleStorageBucket> {
        var body: [String: Any] = [:]
        var query = ""
        
        body["acl"] = try acl.map { try $0.toEncodedDictionary() }
        
        if let queryParameters = queryParameters {
            query = queryParameters.queryParameters
        }
        
        
        if let billing = billing {
            body["billing"] = try billing.toEncodedDictionary()
        }
        
        if let cors = cors {
            body["cors"] = try cors.map { try $0.toEncodedDictionary() }
        }
        
        if let defaultObjectAcl = defaultObjectAcl {
            body["defaultObjectAcl"] = try defaultObjectAcl.map { try $0.toEncodedDictionary() }
        }
        
        if let encryption = encryption {
            body["encryption"] = try encryption.toEncodedDictionary()
        }
        
        if let labels = labels {
            body["labels"] = labels
        }
        
        if let lifecycle = lifecycle {
            body["lifecycle"] = try lifecycle.toEncodedDictionary()
        }
        
        if let logging = logging {
            body["logging"] = try logging.toEncodedDictionary()
        }
        
        if let storageClass = storageClass {
            body["storageClass"] = storageClass.rawValue
        }
        
        if let versioning = versioning {
            body["versioning"] = try versioning.toEncodedDictionary()
        }
        
        if let website = website {
            body["website"] = try website.toEncodedDictionary()
        }
        
        let requestBody = try JSONSerialization.data(withJSONObject: body).convertToHTTPBody()
        
        return try request.send(method: .PUT, path: "\(endpoint)/\(bucket)", query: query, body: requestBody)
    }
}
