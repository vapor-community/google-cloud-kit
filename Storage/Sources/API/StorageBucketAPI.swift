//
//  StorageBucket.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 4/17/18.
//

import NIO
import NIOHTTP1
import Foundation

public protocol StorageBucketAPI {
    
    /// Permanently deletes an empty bucket.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/buckets/delete#parameters)
    func delete(bucket: String, queryParameters: [String: String]?) async throws -> EmptyResponse
    
    /// Returns metadata for the specified bucket.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/buckets/get#parameters)
    func get(bucket: String, queryParameters: [String: String]?) async throws -> GoogleCloudStorageBucket
    
    /// Returns an IAM policy for the specified bucket.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/buckets/getIamPolicy#parameters)
    func getIAMPolicy(bucket: String, queryParameters: [String: String]?) async throws -> IAMPolicy
    
    /// Creates a new bucket. Google Cloud Storage uses a flat namespace, so you can't create a bucket with a name that is already in use.
    /// - Parameter name: The name of the bucket.
    /// - Parameter acl: Access controls on the bucket, containing one or more
    /// - Parameter billing: The bucket's billing configuration.
    /// - Parameter cors: The bucket's Cross-Origin Resource Sharing (CORS) configuration.
    /// - Parameter defaultEventBasedHold: Whether or not to automatically apply an eventBasedHold to new objects added to the bucket.
    /// - Parameter defaultObjectAcl: Default access controls to apply to new objects when no ACL is provided. This list defines an entity and role for one or more defaultObjectAccessControls Resources.
    /// - Parameter encryption: Encryption configuration for a bucket.
    /// - Parameter iamConfiguration: The bucket's IAM configuration.
    /// - Parameter labels: User-provided bucket labels, in key/value pairs.
    /// - Parameter lifecycle: The bucket's lifecycle configuration. See lifecycle management for more information.
    /// - Parameter location: The location of the bucket. Object data for objects in the bucket resides in physical storage within this region. Defaults to US. See the developer's guide for the authoritative list.
    /// - Parameter logging: The bucket's logging configuration, which defines the destination bucket and optional name prefix for the current bucket's logs.
    /// - Parameter retentionPolicy: The bucket's retention policy, which defines the minimum age an object in the bucket must have to be deleted or overwritten.
    /// - Parameter storageClass: The bucket's default storage class, used whenever no storageClass is specified for a newly-created object. Valid values include `MULTI_REGIONAL`, `REGIONAL`, `STANDARD`, `NEARLINE`, `COLDLINE`, and `DURABLE_REDUCED_AVAILABILITY`. If storageClass is not specified when the bucket is created, it defaults to STANDARD. For more information, see storage classes.
    /// - Parameter versioning: The bucket's versioning configuration.
    /// - Parameter website: The bucket's website configuration, controlling how the service behaves when accessing bucket contents as a web site. See the Static Website Examples for more information.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/buckets/insert#parameters)
    func insert(name: String,
                acl: [[String: Any]]?,
                billing: [String: Any]?,
                cors: [[String: Any]]?,
                defaultEventBasedHold: Bool?,
                defaultObjectAcl: [[String: Any]]?,
                encryption: [String: Any]?,
                iamConfiguration: [String: Any]?,
                labels: [String: String]?,
                lifecycle: [String: Any]?,
                location: String?,
                logging: [String: Any]?,
                rententionPolicy: [String: Any]?,
                storageClass: GoogleCloudStorageClass?,
                versioning: [String: Any]?,
                website: [String: Any]?,
                queryParameters: [String: String]?) async throws -> GoogleCloudStorageBucket
    
    /// Retrieves a list of buckets for a given project.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/buckets/list#parameters)
    func list(queryParameters: [String: String]?) async throws -> GoogleCloudStorageBucketList
    
    /// Permanently locks the retention policy that is currently applied to the specified bucket.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter ifMetagenerationMatch: Makes the success of the request conditional on whether the bucket's current metageneration matches the given value.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/buckets/lockRetentionPolicy#parameters)
    func lockRetentionPolicy(bucket: String, ifMetagenerationMatch: Int, queryParameters: [String: String]?) async throws -> GoogleCloudStorageBucket
    
    /// Updates a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate. This method supports patch semantics.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter acl: Access controls on the bucket, containing one or more bucketAccessControls Resources.
    /// - Parameter billing: The bucket's billing configuration.
    /// - Parameter cors: The bucket's Cross-Origin Resource Sharing (CORS) configuration.
    /// - Parameter defaultEventBasedHold: Whether or not to automatically apply an eventBasedHold to new objects added to the bucket.
    /// - Parameter defaultObjectAcl: Default access controls to apply to new objects when no ACL is provided. This list defines an entity and role for one or more defaultObjectAccessControls Resources.
    /// - Parameter encryption: Encryption configuration for a bucket.
    /// - Parameter iamConfiguration: The bucket's IAM configuration.
    /// - Parameter labels: User-provided bucket labels, in key/value pairs.
    /// - Parameter lifecycle: The bucket's lifecycle configuration. See lifecycle management for more information.
    /// - Parameter logging: The bucket's logging configuration, which defines the destination bucket and optional name prefix for the current bucket's logs.
    /// - Parameter retentionPolicy: The bucket's retention policy, which defines the minimum age an object in the bucket must have to be deleted or overwritten.
    /// - Parameter storageClass: The bucket's default storage class, used whenever no storageClass is specified for a newly-created object. Valid values include `MULTI_REGIONAL`, `REGIONAL`, `STANDARD`, `NEARLINE`, `COLDLINE`, and `DURABLE_REDUCED_AVAILABILITY`. If storageClass is not specified when the bucket is created, it defaults to STANDARD. For more information, see storage classes.
    /// - Parameter versioning: The bucket's versioning configuration.
    /// - Parameter website: The bucket's website configuration, controlling how the service behaves when accessing bucket contents as a web site. See the Static Website Examples for more information.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/buckets/patch#parameters)
    func patch(bucket: String,
               acl: [[String: Any]]?,
               billing: [String: Any]?,
               cors: [[String: Any]]?,
               defaultEventBasedHold: Bool?,
               defaultObjectAcl: [[String: Any]]?,
               encryption: [String: Any]?,
               iamConfiguration: [String: Any]?,
               labels: [String: String]?,
               lifecycle: [String: Any]?,
               logging: [String: Any]?,
               rententionPolicy: [String: Any]?,
               storageClass: GoogleCloudStorageClass?,
               versioning: [String: Any]?,
               website: [String: Any]?,
               queryParameters: [String: String]?) async throws -> GoogleCloudStorageBucket
    
    /// Updates an IAM policy for the specified bucket.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter kind: The kind of item this is. For policies, this field is ignored in a request and is storage#policy in a response.
    /// - Parameter resourceId: The ID of the resource to which this policy belongs. The response for this field is of the form projects/_/buckets/bucket. This field is ignored in a request.
    /// - Parameter bindings: An association between a role, which comes with a set of permissions, and members who may assume that role.
    /// - Parameter etag: HTTP 1.1 Entity tag for the policy.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/buckets/setIamPolicy#parameters)
    func setIAMPolicy(bucket: String,
                      kind: String,
                      resourceId: String,
                      bindings: [[String: Any]],
                      etag: String,
                      queryParameters: [String: String]?) async throws -> IAMPolicy
    
    /// Tests a set of permissions on the given bucket to see which, if any, are held by the caller.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter permissions: Permissions to test.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/buckets/testIamPermissions#parameters)
    func testIAMPermissions(bucket: String, permissions: [String], queryParameters: [String: String]?) async throws -> Permission
    
    /// Updates a bucket. Changes to the bucket are readable immediately after writing, but configuration changes may take time to propagate. This method sets the complete metadata of a bucket. If you want to change some of a bucket's metadata while leaving other parts unaffected, use the PATCH method instead.
    /// - Parameter bucket: Name of a bucket.
    /// - Parameter acl: Access controls on the bucket, containing one or more bucketAccessControls Resources.
    /// - Parameter billing: The bucket's billing configuration.
    /// - Parameter cors: The bucket's Cross-Origin Resource Sharing (CORS) configuration.
    /// - Parameter defaultEventBasedHold: Whether or not to automatically apply an eventBasedHold to new objects added to the bucket.
    /// - Parameter defaultObjectAcl: Default access controls to apply to new objects when no ACL is provided. This list defines an entity and role for one or more defaultObjectAccessControls Resources.
    /// - Parameter encryption: Encryption configuration for a bucket.
    /// - Parameter iamConfiguration: The bucket's IAM configuration.
    /// - Parameter labels: User-provided bucket labels, in key/value pairs.
    /// - Parameter lifecycle: The bucket's lifecycle configuration. See lifecycle management for more information.
    /// - Parameter logging: The bucket's logging configuration, which defines the destination bucket and optional name prefix for the current bucket's logs.
    /// - Parameter rententionPolicy: The bucket's retention policy, which defines the minimum age an object in the bucket must reach before it can be deleted or overwritten.
    /// - Parameter storageClass: The bucket's default storage class, used whenever no storageClass is specified for a newly-created object. Valid values include `MULTI_REGIONAL`, `REGIONAL`, `STANDARD`, `NEARLINE`, `COLDLINE`, and `DURABLE_REDUCED_AVAILABILITY`. If storageClass is not specified when the bucket is created, it defaults to STANDARD. For more information, see storage classes.
    /// - Parameter versioning: The bucket's versioning configuration.
    /// - Parameter website: The bucket's website configuration, controlling how the service behaves when accessing bucket contents as a web site. See the Static Website Examples for more information.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/buckets/update#parameters)
    func update(bucket: String,
                acl: [[String: Any]],
                billing: [String: Any]?,
                cors: [[String: Any]]?,
                defaultEventBasedHold: Bool?,
                defaultObjectAcl: [[String: Any]]?,
                encryption: [String: Any]?,
                iamConfiguration: [String: Any]?,
                labels: [String: String]?,
                lifecycle: [String: Any]?,
                logging: [String: Any]?,
                rententionPolicy: [String: Any]?,
                storageClass: GoogleCloudStorageClass?,
                versioning: [String: Any]?,
                website: [String: Any]?,
                queryParameters: [String: String]?) async throws -> GoogleCloudStorageBucket
}

extension StorageBucketAPI {
    public func delete(
        bucket: String,
        queryParameters: [String: String]? = nil
    ) async throws -> EmptyResponse {
        try await delete(bucket: bucket, queryParameters: queryParameters)
    }
    
    public func get(
        bucket: String,
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorageBucket {
        try await get(bucket: bucket, queryParameters: queryParameters)
    }
    
    public func getIAMPolicy(
        bucket: String,
        queryParameters: [String: String]? = nil
    ) async throws -> IAMPolicy {
        try await getIAMPolicy(bucket: bucket, queryParameters: queryParameters)
    }
        
    public func insert(
        name: String,
        acl: [[String: Any]]? = nil,
        billing: [String: Any]? = nil,
        cors: [[String: Any]]? = nil,
        defaultEventBasedHold: Bool? = nil,
        defaultObjectAcl: [[String: Any]]? = nil,
        encryption: [String: Any]? = nil,
        iamConfiguration: [String: Any]? = nil,
        labels: [String: String]? = nil,
        lifecycle: [String: Any]? = nil,
        location: String? = nil,
        logging: [String: Any]? = nil,
        rententionPolicy: [String: Any]? = nil,
        storageClass: GoogleCloudStorageClass? = nil,
        versioning: [String: Any]? = nil,
        website: [String: Any]? = nil,
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorageBucket {
        try await insert(name: name,
                      acl: acl,
                      billing: billing,
                      cors: cors,
                      defaultEventBasedHold: defaultEventBasedHold,
                      defaultObjectAcl: defaultObjectAcl,
                      encryption: encryption,
                      iamConfiguration: iamConfiguration,
                      labels: labels,
                      lifecycle: lifecycle,
                      location: location,
                      logging: logging,
                      rententionPolicy: rententionPolicy,
                      storageClass: storageClass,
                      versioning: versioning,
                      website: website,
                      queryParameters: queryParameters)
    }
    
    public func list(queryParameters: [String: String]? = nil) async throws -> GoogleCloudStorageBucketList {
        try await list(queryParameters: queryParameters)
    }

    public func lockRetentionPolicy(
        bucket: String,
        ifMetagenerationMatch: Int,
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorageBucket {
        try await lockRetentionPolicy(bucket: bucket, ifMetagenerationMatch: ifMetagenerationMatch, queryParameters: queryParameters)
    }
    
    public func patch(
        bucket: String,
        acl: [[String: Any]]? = nil,
        billing: [String: Any]? = nil,
        cors: [[String: Any]]? = nil,
        defaultEventBasedHold: Bool? = nil,
        defaultObjectAcl: [[String: Any]]? = nil,
        encryption: [String: Any]? = nil,
        iamConfiguration: [String: Any]? = nil,
        labels: [String: String]? = nil,
        lifecycle: [String: Any]? = nil,
        logging: [String: Any]? = nil,
        rententionPolicy: [String: Any]? = nil,
        storageClass: GoogleCloudStorageClass? = nil,
        versioning: [String: Any]? = nil,
        website: [String: Any]? = nil,
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorageBucket {
        try await patch(bucket: bucket,
                        acl: acl,
                        billing: billing,
                        cors: cors,
                        defaultEventBasedHold: defaultEventBasedHold,
                        defaultObjectAcl: defaultObjectAcl,
                        encryption: encryption,
                        iamConfiguration: iamConfiguration,
                        labels: labels,
                        lifecycle: lifecycle,
                        logging: logging,
                        rententionPolicy: rententionPolicy,
                        storageClass: storageClass,
                        versioning: versioning,
                        website: website,
                        queryParameters: queryParameters)
    }
    
    public func setIAMPolicy(
        bucket: String,
        kind: String,
        resourceId: String,
        bindings: [[String: Any]],
        etag: String,
        queryParameters: [String: String]? = nil
    ) async throws -> IAMPolicy {
        try await setIAMPolicy(bucket: bucket,
                               kind: kind,
                               resourceId: resourceId,
                               bindings: bindings,
                               etag: etag,
                               queryParameters: queryParameters)
    }
    
    public func testIAMPermissions(
        bucket: String,
        permissions: [String],
        queryParameters: [String: String]? = nil
    ) async throws -> Permission {
        try await testIAMPermissions(bucket: bucket, permissions: permissions, queryParameters: queryParameters)
    }
    
    public func update(
        bucket: String,
        acl: [[String: Any]],
        billing: [String: Any]? = nil,
        cors: [[String: Any]]? = nil,
        defaultEventBasedHold: Bool? = nil,
        defaultObjectAcl: [[String: Any]]? = nil,
        encryption: [String: Any]? = nil,
        iamConfiguration: [String: Any]? = nil,
        labels: [String: String]? = nil,
        lifecycle: [String: Any]? = nil,
        logging: [String: Any]? = nil,
        rententionPolicy: [String: Any]? = nil,
        storageClass: GoogleCloudStorageClass? = nil,
        versioning: [String: Any]? = nil,
        website: [String: Any]? = nil,
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorageBucket {
        try await update(bucket: bucket,
                         acl: acl,
                         billing: billing,
                         cors: cors,
                         defaultEventBasedHold: defaultEventBasedHold,
                         defaultObjectAcl: defaultObjectAcl,
                         encryption: encryption,
                         iamConfiguration: iamConfiguration,
                         labels: labels,
                         lifecycle: lifecycle,
                         logging: logging,
                         rententionPolicy: rententionPolicy,
                         storageClass: storageClass,
                         versioning: versioning,
                         website: website,
                         queryParameters: queryParameters)
    }
}

public final class GoogleCloudStorageBucketAPI: StorageBucketAPI {
    let endpoint = "https://www.googleapis.com/storage/v1/b"
    let request: GoogleCloudStorageRequest
    
    init(request: GoogleCloudStorageRequest) {
        self.request = request
    }
    
    public func delete(
        bucket: String,
        queryParameters: [String: String]?
    ) async throws -> EmptyResponse {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try await request.send(method: .DELETE, path: "\(endpoint)/\(bucket)", query: queryParams)
    }

    public func get(
        bucket: String,
        queryParameters: [String: String]?
    ) async throws -> GoogleCloudStorageBucket {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try await request.send(method: .GET, path: "\(endpoint)/\(bucket)", query: queryParams)
    }

    public func getIAMPolicy(bucket: String, queryParameters: [String: String]?) async throws -> IAMPolicy {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try await request.send(method: .GET, path: "\(endpoint)/\(bucket)/iam", query: queryParams)
    }
    
    public func insert(
        name: String,
        acl: [[String: Any]]? = nil,
        billing: [String: Any]? = nil,
        cors: [[String: Any]]? = nil,
        defaultEventBasedHold: Bool? = nil,
        defaultObjectAcl: [[String: Any]]? = nil,
        encryption: [String: Any]? = nil,
        iamConfiguration: [String: Any]? = nil,
        labels: [String: String]? = nil,
        lifecycle: [String: Any]? = nil,
        location: String? = nil,
        logging: [String: Any]? = nil,
        rententionPolicy: [String: Any]? = nil,
        storageClass: GoogleCloudStorageClass? = nil,
        versioning: [String: Any]? = nil,
        website: [String: Any]? = nil,
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorageBucket {
        var body: [String: Any] = ["name": name]
        var query = ""

        if var queryParameters = queryParameters {
            queryParameters["project"] = request.project
            query = queryParameters.queryParameters
        } else {
            query = "project=\(request.project)"
        }

        if let acl = acl {
            body["acl"] = acl
        }

        if let billing = billing {
            billing.forEach { body["billing[\($0)]"] = $1 }
        }

        if let cors = cors {
            body["cors"] = cors
        }
        
        if let defaultEventBasedHold = defaultEventBasedHold {
            body["defaultEventBasedHold"] = defaultEventBasedHold
        }

        if let defaultObjectAcl = defaultObjectAcl {
            body["defaultObjectAcl"] = defaultObjectAcl
        }

        if let encryption = encryption {
            encryption.forEach { body["encryption[\($0)]"] = $1 }
        }
        
        if let iamConfiguration = iamConfiguration {
            iamConfiguration.forEach { body["iamConfiguration[\($0)]"] = $1 }
        }

        if let labels = labels {
            labels.forEach { body["labels[\($0)]"] = $1 }
        }

        if let lifecycle = lifecycle {
            lifecycle.forEach { body["lifecycle[\($0)]"] = $1 }
        }

        if let location = location {
            body["location"] = location
        }

        if let logging = logging {
            logging.forEach { body["logging[\($0)]"] = $1 }
        }
        
        if let rententionPolicy = rententionPolicy {
            rententionPolicy.forEach { body["rententionPolicy[\($0)]"] = $1 }
        }

        if let storageClass = storageClass {
            body["storageClass"] = storageClass.rawValue
        }

        if let versioning = versioning {
            versioning.forEach { body["versioning[\($0)]"] = $1 }
        }

        if let website = website {
            website.forEach { body["website[\($0)]"] = $1 }
        }

        let requestBody = try JSONSerialization.data(withJSONObject: body)
        return try await request.send(method: .POST, path: endpoint, query: query, body: .bytes(.init(data: requestBody)))
    }
    
    public func list(queryParameters: [String: String]?) async throws -> GoogleCloudStorageBucketList {
        var query = ""
        
        if var queryParameters = queryParameters {
            queryParameters["project"] = request.project
            query = queryParameters.queryParameters
        } else {
            query = "project=\(request.project)"
        }
        
        return try await request.send(method: .GET, path: endpoint, query: query)
    }
    
    public func lockRetentionPolicy(
        bucket: String,
        ifMetagenerationMatch: Int,
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorageBucket {
        var query = ""
        
        if var queryParameters = queryParameters {
            queryParameters["ifMetagenerationMatch"] = "\(ifMetagenerationMatch)"
            query = queryParameters.queryParameters
        } else {
            query = "ifMetagenerationMatch=\(ifMetagenerationMatch)"
        }
        
        return try await request.send(method: .POST, path: "\(endpoint)/\(bucket)/lockRetentionPolicy", query: query)
    }

    public func patch(
        bucket: String,
        acl: [[String: Any]]? = nil,
        billing: [String: Any]? = nil,
        cors: [[String: Any]]? = nil,
        defaultEventBasedHold: Bool? = nil,
        defaultObjectAcl: [[String: Any]]? = nil,
        encryption: [String: Any]? = nil,
        iamConfiguration: [String: Any]? = nil,
        labels: [String: String]? = nil,
        lifecycle: [String: Any]? = nil,
        logging: [String: Any]? = nil,
        rententionPolicy: [String: Any]? = nil,
        storageClass: GoogleCloudStorageClass? = nil,
        versioning: [String: Any]? = nil,
        website: [String: Any]? = nil,
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorageBucket {
        var body: [String: Any] = [:]
        var query = ""
        
        if let queryParameters = queryParameters {
            query = queryParameters.queryParameters
        }
        
        if let acl = acl {
            body["acl"] = acl
        }
        
        if let billing = billing {
            billing.forEach { body["billing[\($0)]"] = $1 }
        }
        
        if let cors = cors {
            body["cors"] = cors
        }
        
        if let defaultEventBasedHold = defaultEventBasedHold {
            body["defaultEventBasedHold"] = defaultEventBasedHold
        }
        
        if let defaultObjectAcl = defaultObjectAcl {
            body["defaultObjectAcl"] = defaultObjectAcl
        }
        
        if let encryption = encryption {
            encryption.forEach { body["encryption[\($0)]"] = $1 }
        }
        
        if let iamConfiguration = iamConfiguration {
            iamConfiguration.forEach { body["iamConfiguration[\($0)]"] = $1 }
        }
        
        if let labels = labels {
            labels.forEach { body["labels[\($0)]"] = $1 }
        }
        
        if let lifecycle = lifecycle {
            lifecycle.forEach { body["lifecycle[\($0)]"] = $1}
        }
        
        if let logging = logging {
            logging.forEach { body["logging[\($0)]"] = $1}
        }
        
        if let rententionPolicy = rententionPolicy {
            rententionPolicy.forEach { body["rententionPolicy[\($0)]"] = $1}
        }
        
        if let storageClass = storageClass {
            body["storageClass"] = storageClass.rawValue
        }
        
        if let versioning = versioning {
            versioning.forEach { body["versioning[\($0)]"] = $1 }
        }
        
        if let website = website {
            website.forEach { body["website[\($0)]"] = $1 }
        }
        
        let requestBody = try JSONSerialization.data(withJSONObject: body)
        return try await request.send(method: .PATCH, path: endpoint, query: query, body: .bytes(.init(data: requestBody)))
    }

    public func setIAMPolicy(
        bucket: String,
        kind: String,
        resourceId: String,
        bindings: [[String: Any]],
        etag: String,
        queryParameters: [String: String]? = nil
    ) async throws -> IAMPolicy {
        var query = ""

        if let queryParameters = queryParameters {
            query = queryParameters.queryParameters
        }
        
        let body: [String: Any] = ["kind": kind,
                                   "resourceId": resourceId,
                                   "bindings": bindings,
                                   "etag": etag]

        let requestBody = try JSONSerialization.data(withJSONObject: body)
        return try await request.send(method: .PUT, path: "\(endpoint)/\(bucket)/iam", query: query, body: .bytes(.init(data: requestBody)))
    }
    
    public func testIAMPermissions(
        bucket: String,
        permissions: [String],
        queryParameters: [String: String]? = nil
    ) async throws -> Permission {
        var query = ""
        
        if let queryParameters = queryParameters {
            query = queryParameters.queryParameters
            // if there are any permissions it's safe to add an ampersand to the end of the query we currently have.
            if permissions.count > 0 {
                query.append("&")
            }
        }
        
        let perms = permissions.map { "permissions=\($0)" }.joined(separator: "&")
        
        query.append(perms)
        
        return try await request.send(method: .GET, path: "\(endpoint)/\(bucket)/iam/testPermissions", query: query)
    }
    
    public func update(
        bucket: String,
        acl: [[String: Any]],
        billing: [String: Any]? = nil,
        cors: [[String: Any]]? = nil,
        defaultEventBasedHold: Bool? = nil,
        defaultObjectAcl: [[String: Any]]? = nil,
        encryption: [String: Any]? = nil,
        iamConfiguration: [String: Any]? = nil,
        labels: [String: String]? = nil,
        lifecycle: [String: Any]? = nil,
        logging: [String: Any]? = nil,
        rententionPolicy: [String: Any]? = nil,
        storageClass: GoogleCloudStorageClass? = nil,
        versioning: [String: Any]? = nil,
        website: [String: Any]? = nil,
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorageBucket {
        var body: [String: Any] = [:]
        var query = ""
        
        if let queryParameters = queryParameters {
            query = queryParameters.queryParameters
        }
        
        body["acl"] = acl
        
        if let billing = billing {
            billing.forEach { body["billing[\($0)]"] = $1 }
        }
        
        if let cors = cors {
            body["cors"] = cors
        }
        
        if let defaultEventBasedHold = defaultEventBasedHold {
            body["defaultEventBasedHold"] = defaultEventBasedHold
        }
        
        if let defaultObjectAcl = defaultObjectAcl {
            body["defaultObjectAcl"] = defaultObjectAcl
        }
        
        if let encryption = encryption {
            encryption.forEach { body["encryption[\($0)]"] = $1 }
        }
        
        if let iamConfiguration = iamConfiguration {
            iamConfiguration.forEach { body["iamConfiguration[\($0)]"] = $1 }
        }
        
        if let labels = labels {
            labels.forEach { body["labels[\($0)]"] = $1 }
        }
        
        if let lifecycle = lifecycle {
            lifecycle.forEach { body["lifecycle[\($0)]"] = $1}
        }
        
        if let logging = logging {
            logging.forEach { body["logging[\($0)]"] = $1}
        }
        
        if let rententionPolicy = rententionPolicy {
            rententionPolicy.forEach { body["rententionPolicy[\($0)]"] = $1}
        }
        
        if let storageClass = storageClass {
            body["storageClass"] = storageClass.rawValue
        }
        
        if let versioning = versioning {
            versioning.forEach { body["versioning[\($0)]"] = $1 }
        }
        
        if let website = website {
            website.forEach { body["website[\($0)]"] = $1 }
        }
        
        let requestBody = try JSONSerialization.data(withJSONObject: body)
        return try await request.send(method: .PUT, path: "\(endpoint)/\(bucket)", query: query, body: .bytes(.init(data: requestBody)))
    }
}
