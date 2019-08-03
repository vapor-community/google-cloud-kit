//
//  StorageClient.swift
//  GoogleCloudProvider
//
//  Created by Andrew Edwards on 4/16/18.
//

import Vapor

public enum GoogleCloudStorageError: GoogleCloudError {
    case projectIdMissing
    case unknownError(String)
    
    var localizedDescription: String {
        switch self {
        case .projectIdMissing:
            return "Missing project id for GoogleCloudStorage API. Did you forget to set your project id?"
        case .unknownError(let reason):
            return "An unknown error occured: \(reason)"
        }
    }
    
    public var identifier: String {
        switch self {
        case .projectIdMissing:
            return "missing-project-id"
        case .unknownError(_):
            return "unknown"
        }
    }
    
    public var reason: String { return localizedDescription }
}

public protocol StorageClient: ServiceType {
    var bucketAccessControl: BucketAccessControlAPI { get set }
    var buckets: StorageBucketAPI { get set }
    var channels: ChannelsAPI { get set }
    var defaultObjectAccessControl: DefaultObjectACLAPI { get set }
    var objectAccessControl: ObjectAccessControlsAPI { get set }
    var notifications: StorageNotificationsAPI { get set }
    var object: StorageObjectAPI { get set }
}

public final class GoogleCloudStorageClient: StorageClient {
    public var bucketAccessControl: BucketAccessControlAPI
    public var buckets: StorageBucketAPI
    public var channels: ChannelsAPI
    public var defaultObjectAccessControl: DefaultObjectACLAPI
    public var objectAccessControl: ObjectAccessControlsAPI
    public var notifications: StorageNotificationsAPI
    public var object: StorageObjectAPI

    init(providerconfig: GoogleCloudProviderConfig, storageConfig: GoogleCloudStorageConfig, client: Client) throws {
        // A token implementing OAuthRefreshable. Loaded from credentials from the provider config.
        let refreshableToken = try OAuthCredentialLoader.getRefreshableToken(credentialFilePath: providerconfig.serviceAccountCredentialPath,
                                                                             withConfig: storageConfig,
                                                                             andClient: client)

        // Set the projectId to use for this client. In order of priority:
        // - Environment Variable (PROJECT_ID)
        // - Service Account's projectID
        // - GoogleCloudStorageConfig's .project (optionally configured)
        // - GoogleCloudProviderConfig's .project (optionally configured)
        guard let projectId = ProcessInfo.processInfo.environment["PROJECT_ID"] ??
                                (refreshableToken as? OAuthServiceAccount)?.credentials.projectId ??
                                storageConfig.project ?? providerconfig.project else {
            throw GoogleCloudStorageError.projectIdMissing
        }

        let storageRequest = GoogleCloudStorageRequest(httpClient: client, oauth: refreshableToken, project: projectId)

        bucketAccessControl = GoogleBucketAccessControlAPI(request: storageRequest)
        buckets = GoogleStorageBucketAPI(request: storageRequest)
        channels = GoogleChannelsAPI(request: storageRequest)
        defaultObjectAccessControl = GoogleDefaultObjectACLAPI(request: storageRequest)
        objectAccessControl = GoogleObjectAccessControlsAPI(request: storageRequest)
        notifications = GoogleStorageNotificationsAPI(request: storageRequest)
        object = GoogleStorageObjectAPI(request: storageRequest)
    }

    public static var serviceSupports: [Any.Type] { return [StorageClient.self] }

    public static func makeService(for worker: Container) throws -> GoogleCloudStorageClient {
        let client = try worker.make(Client.self)
        let providerConfig = try worker.make(GoogleCloudProviderConfig.self)
        let storageConfig = try worker.make(GoogleCloudStorageConfig.self)
        return try GoogleCloudStorageClient(providerconfig: providerConfig, storageConfig: storageConfig, client: client)
    }
}
