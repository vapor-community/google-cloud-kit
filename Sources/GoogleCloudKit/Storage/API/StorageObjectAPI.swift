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
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/objects/get#parameters)
    func getMedia(bucket: String, object: String, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorgeDataResponse>
    
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
    
//    func list(bucket: String, queryParameters: [String: String]?) -> EventLoopFuture<StorageObjectList>
//    func patch(bucket: String, objectName: String, object: GoogleStorageObject?, queryParameters: [String: String]?) -> EventLoopFuture<GoogleStorageObject>
//    func rewrite(destinationBucket: String, destinationObject: String, sourceBucket: String, sourceObject: String, object: GoogleStorageObject?, queryParameters: [String: String]?) -> EventLoopFuture<StorageRewriteObject>
//    func update(bucket: String, objectName: String, object: GoogleStorageObject, queryParameters: [String: String]?) -> EventLoopFuture<GoogleStorageObject>
//    func watchAll(bucket: String, notificationChannel: StorageNotificationChannel, queryParameters: [String: String]?) -> EventLoopFuture<StorageNotificationChannel>
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
    
    public func getMedia(bucket: String, object: String, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorgeDataResponse> {
        return getMedia(bucket: bucket, object: object, queryParameters: queryParameters)
    }
    
    public func createSimpleUpload(bucket: String,
                                   data: Data,
                                   name: String,
                                   contentType: String,
                                   queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageObject> {
        return createSimpleUpload(bucket: bucket, data: data, name: name, contentType: contentType, queryParameters: queryParameters)
    }
    
//    public func list(bucket: String, queryParameters: [String: String]? = nil) -> EventLoopEventLoopFuture<StorageObjectList> {
//        return try list(bucket: bucket, queryParameters: queryParameters)
//    }
//
//    public func patch(bucket: String, objectName: String, object: GoogleStorageObject? = nil, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleStorageObject> {
//        return try patch(bucket: bucket, objectName: objectName, object: object, queryParameters: queryParameters)
//    }
//
//    public func rewrite(destinationBucket: String, destinationObject: String, sourceBucket: String, sourceObject: String, object: GoogleStorageObject? = nil, queryParameters: [String: String]? = nil) -> EventLoopFuture<StorageRewriteObject> {
//        return try rewrite(destinationBucket: destinationBucket, destinationObject: destinationObject, sourceBucket: sourceBucket, sourceObject: sourceObject, object: object, queryParameters: queryParameters)
//    }
//
//    public func update(bucket: String, objectName: String, object: GoogleStorageObject, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleStorageObject> {
//        return try update(bucket: bucket, objectName: objectName, object: object, queryParameters: queryParameters)
//    }
//
//    public func watchAll(bucket: String, notificationChannel: StorageNotificationChannel, queryParameters: [String: String]? = nil) -> EventLoopFuture<StorageNotificationChannel> {
//        return try watchAll(bucket: bucket, notificationChannel: notificationChannel, queryParameters: queryParameters)
//    }
}

public final class GoogleCloudStorageObjectAPI: StorageObjectAPI {
    let endpoint = "https://www.googleapis.com/storage/v1/b"
    let uploadEndpoint = "https://www.googleapis.com/storage/v1/b"
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
            return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
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
            return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
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

    public func getMedia(bucket: String, object: String, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorgeDataResponse> {
        var queryParams = ""
        if var queryParameters = queryParameters {
            queryParameters["alt"] = "media"
            queryParams = queryParameters.queryParameters
        } else {
            queryParams = "alt=media"
        }

        return request.send(method: .GET, path: "\(endpoint)/\(bucket)/o/\(object)", query: queryParams)
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
//    
//    /// Retrieves a list of objects matching the criteria.
//    public func list(bucket: String, queryParameters: [String: String]?) -> EventLoopEventLoopFuture<StorageObjectList> {
//        var queryParams = ""
//        if let queryParameters = queryParameters {
//            queryParams = queryParameters.queryParameters
//        }
//        
//        return try request.send(method: .GET, path: "\(endpoint)/\(bucket)/o)", query: queryParams)
//    }
//    
//    /// Updates a data blob's associated metadata. This method supports patch semantics
//    public func patch(bucket: String, objectName: String, object: GoogleStorageObject?, queryParameters: [String: String]?) -> EventLoopFuture<GoogleStorageObject> {
//        var queryParams = ""
//        if let queryParameters = queryParameters {
//            queryParams = queryParameters.queryParameters
//        }
//        
//        var body = ""
//        
//        if let object = object {
//            body = try JSONSerialization.data(withJSONObject: try object.toEncodedDictionary()).convert(to: String.self)
//        }
//        
//        return try request.send(method: .PATCH, path: "\(endpoint)/\(bucket)/o)", query: queryParams, body: body.convertToHTTPBody())
//    }
//    
//    /// Rewrites a source object to a destination object. Optionally overrides metadata.
//    public func rewrite(destinationBucket: String, destinationObject: String, sourceBucket: String, sourceObject: String, object: GoogleStorageObject?, queryParameters: [String: String]?) -> EventLoopFuture<StorageRewriteObject> {
//        var queryParams = ""
//        if let queryParameters = queryParameters {
//            queryParams = queryParameters.queryParameters
//        }
//        
//        var body = ""
//        
//        if let object = object {
//            body = try JSONSerialization.data(withJSONObject: try object.toEncodedDictionary()).convert(to: String.self)
//        }
//        
//        return try request.send(method: .POST, path: "\(endpoint)/\(sourceBucket)/o/\(sourceObject)/rewriteTo/b/\(destinationBucket)/o/\(destinationObject)", query: queryParams, body: body.convertToHTTPBody())
//    }
//    
//    /// Updates an object's metadata.
//    public func update(bucket: String, objectName: String, object: GoogleStorageObject, queryParameters: [String: String]?) -> EventLoopFuture<GoogleStorageObject> {
//        var queryParams = ""
//        if let queryParameters = queryParameters {
//            queryParams = queryParameters.queryParameters
//        }
//        
//        let body = try JSONSerialization.data(withJSONObject: try object.toEncodedDictionary()).convertToHTTPBody()
//        
//        return try request.send(method: .PUT, path: "\(endpoint)/\(bucket)/o)", query: queryParams, body: body)
//    }
//    
//    /// Watch for changes on all objects in a bucket.
//    public func watchAll(bucket: String, notificationChannel: StorageNotificationChannel, queryParameters: [String: String]?) -> EventLoopFuture<StorageNotificationChannel> {
//        var queryParams = ""
//        if let queryParameters = queryParameters {
//            queryParams = queryParameters.queryParameters
//        }
//        
//        let body = try JSONSerialization.data(withJSONObject: try notificationChannel.toEncodedDictionary()).convertToHTTPBody()
//        
//        return try request.send(method: .POST, path: "\(endpoint)/\(bucket)/o/watch)", query: queryParams, body: body)
//    }
}
