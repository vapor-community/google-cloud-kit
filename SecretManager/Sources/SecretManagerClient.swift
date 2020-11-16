import Core
import Foundation
import AsyncHTTPClient
import NIO

public final class GoogleCloudSecretManagerClient {
    
    public var secrets: SecretsAPI
    var secretManagerRequest: GoogleCloudSecretManagerRequest
    
    /// Initialize a client for interacting with the Google Cloud Secret Manager API
    /// - Parameter credentials: The Credentials to use when authenticating with the APIs
    /// - Parameter config: The configuration for the Cloud Datastore API
    /// - Parameter httpClient: An `HTTPClient` used for making API requests.
    /// - Parameter eventLoop: The EventLoop used to perform the work on.
    /// - Parameter base: The base URL to use for the Datastore API
    public init(credentials: GoogleCloudCredentialsConfiguration,
                config: GoogleCloudSecretManagerConfiguration,
                httpClient: HTTPClient,
                eventLoop: EventLoop,
                base: String = "https://secretmanager.googleapis.com") throws {
        /// A token implementing `OAuthRefreshable`. Loaded from credentials specified by `GoogleCloudCredentialsConfiguration`.
        let refreshableToken = OAuthCredentialLoader.getRefreshableToken(credentials: credentials,
                                                                         withConfig: config,
                                                                         andClient: httpClient,
                                                                         eventLoop: eventLoop)
        
        /// Set the projectId to use for this client. In order of priority:
        /// - Environment Variable (PROJECT_ID)
        /// - Service Account's projectID
        /// - `GoogleCloudSecretManagerConfigurations` `project` property (optionally configured).
        /// - `GoogleCloudCredentialsConfiguration's` `project` property (optionally configured).
        
        guard let projectId = ProcessInfo.processInfo.environment["PROJECT_ID"] ??
                              (refreshableToken as? OAuthServiceAccount)?.credentials.projectId ??
                              config.project ?? credentials.project else {
            throw GoogleCloudSecretManagerError.projectIdMissing
        }
        
        secretManagerRequest = GoogleCloudSecretManagerRequest(httpClient: httpClient,
                                                       eventLoop: eventLoop,
                                                       oauth: refreshableToken,
                                                       project: projectId)
        
        secrets = GoogleCloudSecretManagerSecretsAPI(request: secretManagerRequest, endpoint: base)
    }
    
    /// Hop to a new eventloop to execute requests on.
    /// - Parameter eventLoop: The eventloop to execute requests on.
    public func hopped(to eventLoop: EventLoop) -> GoogleCloudSecretManagerClient {
        secretManagerRequest.eventLoop = eventLoop
        return self
    }
}
