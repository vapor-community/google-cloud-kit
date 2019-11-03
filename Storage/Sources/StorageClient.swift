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
    private var client: HTTPClient
    
    public init(configuration: GoogleCloudCredentialsConfiguration, storageConfig: GoogleCloudStorageConfiguration, eventLoop: EventLoop) throws {
        client = HTTPClient(eventLoopGroupProvider: .shared(eventLoop),
                                configuration: HTTPClient.Configuration(ignoreUncleanSSLShutdown: true))
        // A token implementing OAuthRefreshable. Loaded from credentials from the provider config.
        let refreshableToken = try OAuthCredentialLoader.getRefreshableToken(credentialFilePath: configuration.serviceAccountCredentialsPath,
                                                                             withConfig: storageConfig,
                                                                             andClient: client)

        // Set the projectId to use for this client. In order of priority:
        // - Environment Variable (PROJECT_ID)
        // - Service Account's projectID
        // - GoogleCloudStorageConfigurations `project` property (optionally configured).
        // - GoogleCloudCredentialsConfiguration's `project` property (optionally configured).
        
        guard let projectId = ProcessInfo.processInfo.environment["PROJECT_ID"] ??
                                (refreshableToken as? OAuthServiceAccount)?.credentials.projectId ??
                                storageConfig.project ?? configuration.project else {
            try? client.syncShutdown()
            throw GoogleCloudStorageError.projectIdMissing
        }

        let storageRequest = GoogleCloudStorageRequest(httpClient: client, oauth: refreshableToken, project: projectId)

        bucketAccessControl = GoogleCloudStorageBucketAccessControlAPI(request: storageRequest)
        buckets = GoogleCloudStorageBucketAPI(request: storageRequest)
        channels = GoogleCloudStorageChannelsAPI(request: storageRequest)
        defaultObjectAccessControl = GoogleCloudStorageDefaultObjectACLAPI(request: storageRequest)
        objectAccessControl = GoogleCloudStorageObjectAccessControlsAPI(request: storageRequest)
        notifications = GoogleCloudStorageNotificationsAPI(request: storageRequest)
        object = GoogleCloudStorageObjectAPI(request: storageRequest)
    }
    
    deinit {
        try? client.syncShutdown()
    }
}
