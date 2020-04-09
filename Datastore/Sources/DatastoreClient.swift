import Core
import Foundation
import AsyncHTTPClient
import NIO

public final class GoogleCloudDatastoreClient {

    public var project: DatastoreProjectAPI
    var datastoreRequest: GoogleCloudDatastoreRequest
    
    /// Initialize a client for interacting with the Google Cloud Storage API
    /// - Parameter credentials: The Credentials to use when authenticating with the APIs
    /// - Parameter storageConfig: The storage configuration for the Cloud Storage API
    /// - Parameter httpClient: An `HTTPClient` used for making API requests.
    /// - Parameter eventLoop: The EventLoop used to perform the work on.
    /// - Parameter base: The base URL to use for the Datastore API
    public init(credentials: GoogleCloudCredentialsConfiguration,
                config: GoogleCloudDatastoreConfiguration,
                httpClient: HTTPClient,
                eventLoop: EventLoop,
                base: String = "https://datastore.googleapis.com") throws {
        /// A token implementing `OAuthRefreshable`. Loaded from credentials specified by `GoogleCloudCredentialsConfiguration`.
        let refreshableToken = OAuthCredentialLoader.getRefreshableToken(credentials: credentials,
                                                                         withConfig: config,
                                                                         andClient: httpClient,
                                                                         eventLoop: eventLoop)

        /// Set the projectId to use for this client. In order of priority:
        /// - Environment Variable (PROJECT_ID)
        /// - Service Account's projectID
        /// - `GoogleCloudStorageConfigurations` `project` property (optionally configured).
        /// - `GoogleCloudCredentialsConfiguration's` `project` property (optionally configured).
        
        guard let projectId = ProcessInfo.processInfo.environment["PROJECT_ID"] ??
                                (refreshableToken as? OAuthServiceAccount)?.credentials.projectId ??
                                config.project ?? credentials.project else {
            throw GoogleCloudDatastoreError.projectIdMissing
        }

        datastoreRequest = GoogleCloudDatastoreRequest(httpClient: httpClient,
                                                   eventLoop: eventLoop,
                                                   oauth: refreshableToken,
                                                   project: projectId)

        project = GoogleCloudDatastoreProjectAPI(request: datastoreRequest, endpoint: base)
    }
    
    /// Hop to a new eventloop to execute requests on.
    /// - Parameter eventLoop: The eventloop to execute requests on.
    public func hopped(to eventLoop: EventLoop) -> GoogleCloudDatastoreClient {
        datastoreRequest.eventLoop = eventLoop
        return self
    }
}
