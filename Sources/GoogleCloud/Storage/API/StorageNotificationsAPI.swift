//
//  StorageNotificationsAPI.swift
//  GoogleCloudProvider
//
//  Created by Andrew Edwards on 5/20/18.
//

import Vapor

public protocol StorageNotificationsAPI {
    func delete(bucket: String, notification: String, queryParameters: [String: String]?) throws -> Future<EmptyResponse>
    func get(bucket: String, notification: String, queryParameters: [String: String]?) throws -> Future<StorageNotification>
    func create(bucket: String, notification: StorageNotification, queryParameters: [String: String]?) throws -> Future<StorageNotification>
    func list(bucket: String, queryParameters: [String: String]?) throws -> Future<StorageNotificationsList>
}

extension StorageNotificationsAPI {
    public func delete(bucket: String, notification: String, queryParameters: [String: String]? = nil) throws -> Future<EmptyResponse> {
        return try delete(bucket: bucket, notification: notification, queryParameters: queryParameters)
    }
    
    public func get(bucket: String, notification: String, queryParameters: [String: String]? = nil) throws -> Future<StorageNotification> {
        return try get(bucket: bucket, notification: notification, queryParameters: queryParameters)
    }
    
    public func create(bucket: String, notification: StorageNotification, queryParameters: [String: String]? = nil) throws -> Future<StorageNotification> {
        return try create(bucket: bucket, notification: notification, queryParameters: queryParameters)
    }
    
    public func list(bucket: String, queryParameters: [String: String]? = nil) throws -> Future<StorageNotificationsList> {
        return try list(bucket: bucket, queryParameters: queryParameters)
    }
}

public final class GoogleStorageNotificationsAPI: StorageNotificationsAPI {
    let endpoint = "https://www.googleapis.com/storage/v1/b"
    let request: GoogleCloudStorageRequest
    
    init(request: GoogleCloudStorageRequest) {
        self.request = request
    }
    
    /// Permanently deletes a notification subscription.
    public func delete(bucket: String, notification: String, queryParameters: [String: String]?) throws -> Future<EmptyResponse> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try request.send(method: .DELETE, path: "\(endpoint)/\(bucket)/notificationConfigs/\(notification)", query: queryParams)
    }
    
    /// View a notification configuration.
    public func get(bucket: String, notification: String, queryParameters: [String: String]?) throws -> Future<StorageNotification> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try request.send(method: .GET, path: "\(endpoint)/\(bucket)/notificationConfigs/\(notification)", query: queryParams)
    }
    
    /// Creates a notification subscription for a given bucket.
    public func create(bucket: String, notification: StorageNotification, queryParameters: [String: String]?) throws -> Future<StorageNotification> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        let body = try JSONSerialization.data(withJSONObject: try notification.toEncodedDictionary()).convertToHTTPBody()
        
        return try request.send(method: .POST, path: "\(endpoint)/\(bucket)/notificationConfigs", query: queryParams, body: body)
    }
    
    /// Retrieves a list of notification subscriptions for a given bucket.
    public func list(bucket: String, queryParameters: [String: String]?) throws -> Future<StorageNotificationsList> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try request.send(method: .GET, path: "\(endpoint)/\(bucket)/notificationConfigs", query: queryParams)
    }
}
