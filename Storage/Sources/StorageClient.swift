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

public struct GoogleCloudStorageClient {
    public var bucketAccessControl: BucketAccessControlAPI
    public var buckets: StorageBucketAPI
    public var channels: ChannelsAPI
    public var defaultObjectAccessControl: DefaultObjectACLAPI
    public var objectAccessControl: ObjectAccessControlsAPI
    public var notifications: StorageNotificationsAPI
    public var object: StorageObjectAPI

    let cloudStorageRequest: GoogleCloudStorageRequest
    
    public init(strategy: CredentialsLoadingStrategy,
                client: HTTPClient,
                scope: [GoogleCloudStorageScope]) async throws {
        let resolvedCredentials = try await CredentialsResolver.resolveCredentials(strategy: strategy)
        
        switch resolvedCredentials {
        case .gcloud(let gCloudCredentials):
            let provider = GCloudCredentialsProvider(client: client, credentials: gCloudCredentials)
            cloudStorageRequest = .init(tokenProvider: provider, client: client, project: gCloudCredentials.quotaProjectId)
            
        case .serviceAccount(let serviceAccountCredentials):
            let provider = ServiceAccountCredentialsProvider(client: client,
                                                             credentials: serviceAccountCredentials,
                                                             scope: scope)
            cloudStorageRequest = .init(tokenProvider: provider, client: client, project: serviceAccountCredentials.projectId)
            
        case .computeEngine(let metadataUrl):
            let projectId = ProcessInfo.processInfo.environment["PROJECT_ID"] ?? "default"
            switch strategy {
            case .computeEngine(let client):
                let provider = ComputeEngineCredentialsProvider(client: client, scopes: scope, url: metadataUrl)
                cloudStorageRequest = .init(tokenProvider: provider, client: client, project: projectId)
            default:
                let provider = ComputeEngineCredentialsProvider(client: client, scopes: scope, url: metadataUrl)
                cloudStorageRequest = .init(tokenProvider: provider, client: client, project: projectId)
            }
        }
        
        bucketAccessControl = GoogleCloudStorageBucketAccessControlAPI(request: cloudStorageRequest)
        buckets = GoogleCloudStorageBucketAPI(request: cloudStorageRequest)
        channels = GoogleCloudStorageChannelsAPI(request: cloudStorageRequest)
        defaultObjectAccessControl = GoogleCloudStorageDefaultObjectACLAPI(request: cloudStorageRequest)
        objectAccessControl = GoogleCloudStorageObjectAccessControlsAPI(request: cloudStorageRequest)
        notifications = GoogleCloudStorageNotificationsAPI(request: cloudStorageRequest)
        object = GoogleCloudStorageObjectAPI(request: cloudStorageRequest)
    }
}
