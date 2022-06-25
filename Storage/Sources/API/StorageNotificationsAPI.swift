//
//  StorageNotificationsAPI.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 5/20/18.
//

import Core
import NIO
import NIOHTTP1
import Foundation

public protocol StorageNotificationsAPI {
    
    /// Permanently deletes a Cloud Pub/Sub notification configuration from a bucket.
    /// - Parameter bucket: The parent bucket of the notification.
    /// - Parameter notification: ID of the notification to delete.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/notifications/delete#parameters)
    func delete(bucket: String, notification: String, queryParameters: [String: String]?) async throws -> EmptyResponse
    
    /// View a Cloud Pub/Sub notification configuration on a given bucket.
    /// - Parameter bucket: The parent bucket of the notification.
    /// - Parameter notification: Notification ID
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/notifications/get#parameters)
    func get(bucket: String, notification: String, queryParameters: [String: String]?) async throws -> StorageNotification
    
    /// Creates a Cloud Pub/Sub notification configuration for a given bucket.
    /// - Parameter bucket: The parent bucket of the notification.
    /// - Parameter topic: The Cloud Pub/Sub topic to which this subscription publishes. Formatted as: '//pubsub.googleapis.com/projects/{project-identifier}/topics/{my-topic}'
    /// - Parameter payloadFormat: The desired content of the Payload.
    /// - Parameter customAttributes: An optional list of additional attributes to attach to each Cloud Pub/Sub message published for this notification subscription.
    /// - Parameter eventTypes: If present, only send notifications about listed event types. If empty, send notifications for all event types.
    /// - Parameter objectNamePrefix: If present, only apply this notification configuration to object names that begin with this prefix.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/notifications/insert#parameters)
    func insert(bucket: String,
                topic: String,
                payloadFormat: String,
                customAttributes: [String: Any]?,
                eventTypes: [String]?,
                objectNamePrefix: String?,
                queryParameters: [String: String]?) async throws -> StorageNotification
    
    /// Retrieves a list of Cloud Pub/Sub notification configurations for a given bucket.
    /// - Parameter bucket: Name of a Google Cloud Storage bucket.
    /// - Parameter queryParameters: [Optional query parameters](https://cloud.google.com/storage/docs/json_api/v1/notifications/list#parameters)
    func list(bucket: String, queryParameters: [String: String]?) async throws -> StorageNotificationsList
}

extension StorageNotificationsAPI {
    public func delete(
        bucket: String,
        notification: String,
        queryParameters: [String: String]? = nil
    ) async throws -> EmptyResponse {
        try await delete(
            bucket: bucket,
            notification: notification,
            queryParameters: queryParameters
        )
    }
    
    public func get(
        bucket: String,
        notification: String,
        queryParameters: [String: String]? = nil
    ) async throws -> StorageNotification {
        try await get(
            bucket: bucket,
            notification: notification,
            queryParameters: queryParameters
        )
    }
    
    public func insert(
        bucket: String,
        topic: String,
        payloadFormat: String,
        customAttributes: [String: Any]? = nil,
        eventTypes: [String]? = nil,
        objectNamePrefix: String? = nil,
        queryParameters: [String: String]? = nil
    ) async throws -> StorageNotification {
        try await insert(
            bucket: bucket,
            topic: topic,
            payloadFormat: payloadFormat,
            customAttributes: customAttributes,
            eventTypes: eventTypes,
            objectNamePrefix: objectNamePrefix,
            queryParameters: queryParameters
        )
    }
    
    public func list(
        bucket: String,
        queryParameters: [String: String]? = nil
    ) async throws -> StorageNotificationsList {
        try await list(
            bucket: bucket,
            queryParameters: queryParameters
        )
    }
}

public final class GoogleCloudStorageNotificationsAPI: StorageNotificationsAPI {
    let endpoint = "https://www.googleapis.com/storage/v1/b"
    let request: GoogleCloudStorageRequest
    
    init(request: GoogleCloudStorageRequest) {
        self.request = request
    }
    
    public func delete(
        bucket: String,
        notification: String,
        queryParameters: [String: String]?
    ) async throws -> EmptyResponse {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try await request.send(method: .DELETE,
                                      path: "\(endpoint)/\(bucket)/notificationConfigs/\(notification)",
                                      query: queryParams)
    }
    
    public func get(
        bucket: String,
        notification: String,
        queryParameters: [String: String]?
    ) async throws -> StorageNotification {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try await request.send(method: .GET,
                                      path: "\(endpoint)/\(bucket)/notificationConfigs/\(notification)",
                                      query: queryParams)
    }

    public func insert(
        bucket: String,
        topic: String,
        payloadFormat: String,
        customAttributes: [String: Any]?,
        eventTypes: [String]?,
        objectNamePrefix: String?,
        queryParameters: [String: String]?
    ) async throws -> StorageNotification {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        var body: [String: Any] = ["topic": topic,
                                   "payload_format": payloadFormat]
        
        if let customAttributes = customAttributes {
            customAttributes.forEach { body["custom_attributes[\($0)]"]  = $1}
        }
        
        if let eventTypes = eventTypes {
            body["event_types"] = eventTypes
        }
        
        if let objectNamePrefix = objectNamePrefix {
            body["object_name_prefix"] = objectNamePrefix
        }
        
        let requestBody = try JSONSerialization.data(withJSONObject: body)
        return try await request.send(method: .POST,
                                      path: "\(endpoint)/\(bucket)/notificationConfigs",
                                      query: queryParams,
                                      body: .bytes(.init(data: requestBody)))
    }
    
    public func list(
        bucket: String,
        queryParameters: [String: String]?
    ) async throws -> StorageNotificationsList {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        return try await request.send(method: .GET,
                                      path: "\(endpoint)/\(bucket)/notificationConfigs",
                                      query: queryParams)
    }
}
