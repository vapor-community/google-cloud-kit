//
//  StorageObjectAPI.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 5/20/18.
//

import NIO
import NIOHTTP1
import Foundation

public protocol StorageObjectAPI {
    
    /// Concatenates a list of existing objects into a new object in the same bucket.
    /// - Parameter bucket: Name of the bucket containing the source objects. The destination object is stored in this bucket.
    /// - Parameter destinationObject: Name of the new object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
    /// - Parameter kind: The kind of item this is.
    /// - Parameter destination: Properties of the resulting object.
    /// - Parameter sourceObjects: The list of source objects that will be concatenated into a single object.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/objects/compose#parameters)
    func compose(bucket: String,
                 destinationObject: String,
                 kind: String,
                 destination: [String: Any],
                 sourceObjects: [[String: Any]],
                 queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject>
    
    /// Copies a source object to a destination object. Optionally overrides metadata.
    /// - Parameter destinationBucket: Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
    /// - Parameter destinationObject: Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
    /// - Parameter sourceBucket: Name of the bucket in which to find the source object.
    /// - Parameter sourceObject: Name of the source object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
    /// - Parameter object: Object resource metadata.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/objects/copy#parameters)
    func copy(destinationBucket: String,
              destinationObject: String,
              sourceBucket: String,
              sourceObject: String,
              object: [String: Any],
              queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject>
    
    /// Deletes an object and its metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
    /// - Parameter bucket: Name of the bucket in which the object resides.
    /// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/objects/delete#parameters)
    func delete(bucket: String, object: String, queryParameters: [String: String]?) -> EventLoopFuture<EmptyResponse>
    
    /// Retrieves object metadata.
    /// - Parameter bucket: Name of the bucket in which the object resides.
    /// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/objects/get#parameters)
    func get(bucket: String, object: String, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject>
    
    /// Retrieves object data.
    /// - Parameter bucket: Name of the bucket in which the object resides.
    /// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
    /// - Parameter range: Range of data to download.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/objects/get#parameters)
    func getMedia(bucket: String, object: String, range: ClosedRange<Int>?, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorgeDataResponse>
    
    /// Stores a new object with no metadata.
    /// - Parameter bucket: Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
    /// - Parameter data: The content to be uploaded to a bucket.
    /// - Parameter name: The name of the object. Required if not specified by URL parameter.
    /// - Parameter contentType: Content-Type of the object data. If an object is stored without a Content-Type, it is served as application/octet-stream.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/objects/insert#parameters)
    func createSimpleUpload(bucket: String,
                            data: Data,
                            name: String,
                            contentType: String,
                            queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject>
    
    /// Retrieves a list of objects matching the criteria.
    /// - Parameter bucket: Name of the bucket in which to look for objects.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/list/insert#parameters)
    func list(bucket: String, queryParameters: [String: String]?) -> EventLoopFuture<StorageObjectList>
    
    /// Updates a data blob's associated metadata. This method supports patch semantics.
    /// - Parameter bucket: Name of the bucket in which the object resides.
    /// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
    /// - Parameter metadata: The relevant portions of an object resource.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/objects/patch#parameters)
    func patch(bucket: String,
               object: String,
               metadata: [String: Any],
               queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject>
    
    /// Rewrites a source object to a destination object. Optionally overrides metadata.
    /// - Parameter destinationBucket: Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
    /// - Parameter destinationObject: Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
    /// - Parameter sourceBucket: Name of the bucket in which to find the source object.
    /// - Parameter sourceObject: Name of the source object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
    /// - Parameter metadata: Metadata to apply to the rewritten object.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/objects/rewrite#parameters)
    func rewrite(destinationBucket: String,
                 destinationObject: String,
                 sourceBucket: String,
                 sourceObject: String,
                 metadata: [String: Any],
                 queryParameters: [String: String]?) -> EventLoopFuture<StorageRewriteObject>
    
    /// Updates an object's metadata.
    /// - Parameter bucket: Name of the bucket in which the object resides.
    /// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
    /// - Parameter acl: Access controls on the object, containing one or more objectAccessControls Resources.
    /// - Parameter cacheControl: Cache-Control directive for the object data. If omitted, and the object is accessible to all anonymous users, the default will be public, max-age=3600.
    /// - Parameter contentDisposition: Content-Disposition of the object data.
    /// - Parameter contentEncoding: Content-Encoding of the object data.
    /// - Parameter contentLanguage: Content-Language of the object data.
    /// - Parameter contentType: Content-Type of the object data. If an object is stored without a Content-Type, it is served as application/octet-stream.
    /// - Parameter eventBasedHold: Whether or not the object is subject to an event-based hold.
    /// - Parameter metadata: User-provided metadata, in key/value pairs.
    /// - Parameter temporaryHold: Whether or not the object is subject to a temporary hold.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/objects/update#parameters)
    func update(bucket: String,
                object: String,
                acl: [[String: Any]],
                cacheControl: String?,
                contentDisposition: String?,
                contentEncoding: String?,
                contentLanguage: String?,
                contentType: String?,
                eventBasedHold: Bool?,
                metadata: [String: String]?,
                temporaryHold: Bool?,
                queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject>
    
    /// Watch for changes on all objects in a bucket.
    /// - Parameter bucket: Name of the bucket in which to look for objects.
    /// - Parameter kind: Identifies this as a notification channel used to watch for changes to a resource. Value: the fixed string "api#channel".
    /// - Parameter id: A UUID or similar unique string that identifies this channel.
    /// - Parameter resourceId: An opaque ID that identifies the resource being watched on this channel. Stable across different API versions.
    /// - Parameter resourceUri: A version-specific identifier for the watched resource.
    /// - Parameter token: An arbitrary string delivered to the target address with each notification delivered over this channel. Optional.
    /// - Parameter expiration: Date and time of notification channel expiration, expressed as a Unix timestamp, in milliseconds. Optional.
    /// - Parameter type: The type of delivery mechanism used for this channel. Value: the fixed string `"WEBHOOK"`.
    /// - Parameter address: The address where notifications are delivered for this channel.
    /// - Parameter params: Additional parameters controlling delivery channel behavior. Optional.
    /// - Parameter payload: A Boolean value to indicate whether payload is wanted. Optional.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/objects/watchAll#parameters)
    func watchAll(bucket: String,
                  kind: String,
                  id: String,
                  resourceId: String,
                  resourceUri: String,
                  token: String?,
                  expiration: Date?,
                  type: String,
                  address: String,
                  params: [String: String]?,
                  payload: Bool?,
                  queryParameters: [String: String]?) -> EventLoopFuture<StorageNotificationChannel>
}

extension StorageObjectAPI {
    public func compose(bucket: String,
                        destinationObject: String,
                        kind: String,
                        destination: [String: Any],
                        sourceObjects: [[String: Any]],
                        queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject> {
        return compose(bucket: bucket,
                       destinationObject: destinationObject,
                       kind: kind,
                       destination: destination,
                       sourceObjects: sourceObjects,
                       queryParameters: queryParameters)
    }
    
    public func copy(destinationBucket: String,
              destinationObject: String,
              sourceBucket: String,
              sourceObject: String,
              object: [String: Any],
              queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject> {
        return copy(destinationBucket: destinationBucket,
                    destinationObject: destinationObject,
                    sourceBucket: sourceBucket,
                    sourceObject: sourceObject,
                    object: object,
                    queryParameters: queryParameters)
    }
    
    public func delete(bucket: String, object: String, queryParameters: [String: String]? = nil) -> EventLoopFuture<EmptyResponse> {
        return delete(bucket: bucket, object: object, queryParameters: queryParameters)
    }
    
    public func get(bucket: String, object: String, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageObject> {
        return get(bucket: bucket, object: object, queryParameters: queryParameters)
    }
    
    public func getMedia(bucket: String, object: String, range: ClosedRange<Int>? = nil, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorgeDataResponse> {
        return getMedia(bucket: bucket, object: object, range: range, queryParameters: queryParameters)
    }
    
    public func createSimpleUpload(bucket: String,
                                   data: Data,
                                   name: String,
                                   contentType: String,
                                   queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageObject> {
        return createSimpleUpload(bucket: bucket,
                                  data: data,
                                  name: name,
                                  contentType: contentType,
                                  queryParameters: queryParameters)
    }
    
    public func list(bucket: String, queryParameters: [String: String]? = nil) -> EventLoopFuture<StorageObjectList> {
        return list(bucket: bucket, queryParameters: queryParameters)
    }

    public func patch(bucket: String,
                      object: String,
                      metadata: [String: Any],
                      queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageObject> {
        return patch(bucket: bucket,
                     object: object,
                     metadata: metadata,
                     queryParameters: queryParameters)
    }

    public func rewrite(destinationBucket: String,
                        destinationObject: String,
                        sourceBucket: String,
                        sourceObject: String,
                        metadata: [String: Any],
                        queryParameters: [String: String]? = nil) -> EventLoopFuture<StorageRewriteObject> {
        return rewrite(destinationBucket: destinationBucket,
                       destinationObject: destinationObject,
                       sourceBucket: sourceBucket,
                       sourceObject: sourceObject,
                       metadata: metadata,
                       queryParameters: queryParameters)
    }
    
    public func update(bucket: String,
                       object: String,
                       acl: [[String: Any]],
                       cacheControl: String?,
                       contentDisposition: String?,
                       contentEncoding: String?,
                       contentLanguage: String?,
                       contentType: String?,
                       eventBasedHold: Bool?,
                       metadata: [String: String]?,
                       temporaryHold: Bool?,
                       queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject> {
        return update(bucket: bucket,
                      object: object,
                      acl: acl,
                      cacheControl: cacheControl,
                      contentDisposition: contentDisposition,
                      contentEncoding: contentEncoding,
                      contentLanguage: contentLanguage,
                      contentType: contentType,
                      eventBasedHold: eventBasedHold,
                      metadata: metadata,
                      temporaryHold: temporaryHold,
                      queryParameters: queryParameters)
    }
    
    public func watchAll(bucket: String,
                         kind: String,
                         id: String,
                         resourceId: String,
                         resourceUri: String,
                         token: String?,
                         expiration: Date?,
                         type: String,
                         address: String,
                         params: [String: String]?,
                         payload: Bool?,
                         queryParameters: [String: String]?) -> EventLoopFuture<StorageNotificationChannel> {
        return watchAll(bucket: bucket,
                        kind: kind,
                        id: id,
                        resourceId: resourceId,
                        resourceUri: resourceUri,
                        token: token,
                        expiration: expiration,
                        type: type,
                        address: address,
                        params: params,
                        payload: payload,
                        queryParameters: queryParameters)
    }
}

public final class GoogleCloudStorageObjectAPI: StorageObjectAPI {
    let endpoint = "https://www.googleapis.com/storage/v1/b"
    let uploadEndpoint = "https://www.googleapis.com/upload/storage/v1/b"
    let request: GoogleCloudStorageRequest
    
    init(request: GoogleCloudStorageRequest) {
        self.request = request
    }

    public func compose(bucket: String,
                        destinationObject: String,
                        kind: String,
                        destination: [String: Any],
                        sourceObjects: [[String: Any]],
                        queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        do {
            let body: [String: Any] = ["kind": kind,
                                       "destination": destination,
                                       "sourceObjects": sourceObjects]
            let requestBody = try JSONSerialization.data(withJSONObject: body)
            return request.send(method: .POST, path: "\(endpoint)/\(bucket)/o/\(destinationObject)/compose", query: queryParams, body: .data(requestBody))
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func copy(destinationBucket: String,
                     destinationObject: String,
                     sourceBucket: String,
                     sourceObject: String,
                     object: [String: Any],
                     queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: object)
            return request.send(method: .POST, path: "\(endpoint)/\(sourceBucket)/o/\(sourceObject)/copyTo/b/\(destinationBucket)/o/\(destinationObject)", query: queryParams, body: .data(requestBody))
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func delete(bucket: String, object: String, queryParameters: [String: String]?) -> EventLoopFuture<EmptyResponse> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return request.send(method: .DELETE, path: "\(endpoint)/\(bucket)/o/\(object)", query: queryParams)
    }
    
    public func get(bucket: String, object: String, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return request.send(method: .GET, path: "\(endpoint)/\(bucket)/o/\(object)", query: queryParams)
    }

    public func getMedia(bucket: String, object: String, range: ClosedRange<Int>?, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorgeDataResponse> {
        var queryParams = ""
        if var queryParameters = queryParameters {
            queryParameters["alt"] = "media"
            queryParams = queryParameters.queryParameters
        } else {
            queryParams = "alt=media"
        }

        var header: HTTPHeaders = [:]
        
        if let range = range {
            header.add(name: "Range", value: "bytes=\(range.lowerBound)-\(range.upperBound)")
        }
        
        return request.send(method: .GET, headers: headers, path: "\(endpoint)/\(bucket)/o/\(object)", query: queryParams)
    }
    
    public func createSimpleUpload(bucket: String,
                                   data: Data,
                                   name: String,
                                   contentType: String,
                                   queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject> {
        var queryParams = ""
        if var queryParameters = queryParameters {
            queryParameters["name"] = name
            queryParameters["uploadType"] = "media"
            queryParams = queryParameters.queryParameters
        } else {
            queryParams = "uploadType=media&name=\(name)"
        }
                
        let headers: HTTPHeaders = ["Content-Type": contentType]
        
        return request.send(method: .POST, headers: headers, path: "\(uploadEndpoint)/\(bucket)/o", query: queryParams, body: .data(data))
    }
    
    public func list(bucket: String, queryParameters: [String: String]?) -> EventLoopFuture<StorageObjectList> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return request.send(method: .GET, path: "\(endpoint)/\(bucket)/o", query: queryParams)
    }
    
    public func patch(bucket: String,
                      object: String,
                      metadata: [String: Any],
                      queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: metadata)
            return request.send(method: .PATCH, path: "\(endpoint)/\(bucket)/o", query: queryParams, body: .data(requestBody))
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func rewrite(destinationBucket: String,
                        destinationObject: String,
                        sourceBucket: String,
                        sourceObject: String,
                        metadata: [String: Any],
                        queryParameters: [String: String]?) -> EventLoopFuture<StorageRewriteObject> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: metadata)
            return request.send(method: .POST,
                                path: "\(endpoint)/\(sourceBucket)/o/\(sourceObject)/rewriteTo/b/\(destinationBucket)/o/\(destinationObject)",
                                query: queryParams,
                                body: .data(requestBody))
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func update(bucket: String,
                       object: String,
                       acl: [[String: Any]],
                       cacheControl: String?,
                       contentDisposition: String?,
                       contentEncoding: String?,
                       contentLanguage: String?,
                       contentType: String?,
                       eventBasedHold: Bool?,
                       metadata: [String: String]?,
                       temporaryHold: Bool?,
                       queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        var body: [String: Any] = ["acl": acl]
        
        if let cacheControl = cacheControl {
            body["cacheControl"] = cacheControl
        }
        
        if let contentDisposition = contentDisposition {
            body["contentDisposition"] = contentDisposition
        }
        
        if let contentEncoding = contentEncoding {
            body["contentEncoding"] = contentEncoding
        }
        
        if let contentLanguage = contentLanguage {
            body["contentLanguage"] = contentLanguage
        }
        
        if let contentType = contentType {
            body["contentType"] = contentType
        }
        
        if let eventBasedHold = eventBasedHold {
            body["eventBasedHold"] = eventBasedHold
        }
        
        if let metadata = metadata {
            metadata.forEach { body["cacheControl[\($0)]"] = $1 }
        }
        
        if let temporaryHold = temporaryHold {
            body["temporaryHold"] = temporaryHold
        }
        
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: body)
            return request.send(method: .PUT, path: "\(endpoint)/\(bucket)/o/\(object)", query: queryParams, body: .data(requestBody))
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    public func watchAll(bucket: String,
                         kind: String,
                         id: String,
                         resourceId: String,
                         resourceUri: String,
                         token: String?,
                         expiration: Date?,
                         type: String,
                         address: String,
                         params: [String: String]?,
                         payload: Bool?,
                         queryParameters: [String: String]?) -> EventLoopFuture<StorageNotificationChannel> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        var body: [String: Any] = ["kind": kind,
                                   "id": id,
                                   "resourceId": resourceId,
                                   "resourceUri": resourceUri,
                                   "type": type,
                                   "address": address]
        
        if let token = token {
            body["token"] = token
        }
        
        if let expiration = expiration {
            body["expiration"] = Int(expiration.timeIntervalSince1970) * 1000
        }
        
        if let params = params {
            params.forEach { body["params[\($0)]"] = $1 }
        }
        
        if let payload = payload {
            body["payload"] = payload
        }
        
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: body)
            return request.send(method: .POST, path: "\(endpoint)/\(bucket)/o/watch", query: queryParams, body: .data(requestBody))
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
}
