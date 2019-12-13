//
//  StorageClient.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 4/16/18.
//

import Core
import Foundation
import AsyncHTTPClient
import NIO

public final class GoogleCloudStorageClient {
    public var bucketAccessControl: BucketAccessControlAPI
    public var buckets: StorageBucketAPI
    public var channels: ChannelsAPI
    public var defaultObjectAccessControl: DefaultObjectACLAPI
    public var objectAccessControl: ObjectAccessControlsAPI
    public var notifications: StorageNotificationsAPI
    public var object: StorageObjectAPI
    
    /// Initialize a client for interacting with the Google Cloud Storage API
    /// - Parameter credentials: The Credentials to use when authenticating with the APIs
    /// - Parameter storageConfig: The storage configuration for the Cloud Storage API
    /// - Parameter httpClient: An `HTTPClient` used for making API requests.
    /// - Parameter eventLoop: The EventLoop used to perform the work on.
    public init(credentials: GoogleCloudCredentialsConfiguration, storageConfig: GoogleCloudStorageConfiguration, httpClient: HTTPClient, eventLoop: EventLoop) throws {
        /// A token implementing `OAuthRefreshable`. Loaded from credentials specified by `GoogleCloudCredentialsConfiguration`.
        let refreshableToken = try OAuthCredentialLoader.getRefreshableToken(credentialFilePath: credentials.serviceAccountCredentialsPath,
                                                                             withConfig: storageConfig,
                                                                             andClient: httpClient,
                                                                             eventLoop: eventLoop)

        /// Set the projectId to use for this client. In order of priority:
        /// - Environment Variable (PROJECT_ID)
        /// - Service Account's projectID
        /// - `GoogleCloudStorageConfigurations` `project` property (optionally configured).
        /// - `GoogleCloudCredentialsConfiguration's` `project` property (optionally configured).
        
        guard let projectId = ProcessInfo.processInfo.environment["PROJECT_ID"] ??
                                (refreshableToken as? OAuthServiceAccount)?.credentials.projectId ??
                                storageConfig.project ?? credentials.project else {
            throw GoogleCloudStorageError.projectIdMissing
        }

        let storageRequest = GoogleCloudStorageRequest(httpClient: httpClient, eventLoop: eventLoop, oauth: refreshableToken, project: projectId)

        bucketAccessControl = GoogleCloudStorageBucketAccessControlAPI(request: storageRequest)
        buckets = GoogleCloudStorageBucketAPI(request: storageRequest)
        channels = GoogleCloudStorageChannelsAPI(request: storageRequest)
        defaultObjectAccessControl = GoogleCloudStorageDefaultObjectACLAPI(request: storageRequest)
        objectAccessControl = GoogleCloudStorageObjectAccessControlsAPI(request: storageRequest)
        notifications = GoogleCloudStorageNotificationsAPI(request: storageRequest)
        object = GoogleCloudStorageObjectAPI(request: storageRequest)
    }
}
