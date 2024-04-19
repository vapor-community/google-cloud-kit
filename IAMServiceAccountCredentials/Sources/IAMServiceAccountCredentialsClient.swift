import Core
import Foundation
import AsyncHTTPClient
import NIO

public final class IAMServiceAccountCredentialsClient {
    
    public var api: IAMServiceAccountCredentialsAPI
    var request: IAMServiceAccountCredentialsRequest
    
    /// Initialize a client for interacting with the Google Cloud IAM Service Account Credentials API
    /// - Parameter credentials: The Credentials to use when authenticating with the APIs
    /// - Parameter config: The configuration for the IAM Service Account Credentials API
    /// - Parameter httpClient: An `HTTPClient` used for making API requests.
    /// - Parameter eventLoop: The EventLoop used to perform the work on.
    /// - Parameter base: The base URL to use for the IAM Service Account Credentials API
    public init(
        credentials: GoogleCloudCredentialsConfiguration,
        config: IAMServiceAccountCredentialsConfiguration,
        httpClient: HTTPClient,
        eventLoop: EventLoop,
        base: String = "https://iamcredentials.googleapis.com"
    ) throws {
        
        /// A token implementing `OAuthRefreshable`. Loaded from credentials specified by `GoogleCloudCredentialsConfiguration`.
        let refreshableToken = OAuthCredentialLoader.getRefreshableToken(
            credentials: credentials,
            withConfig: config,
            andClient: httpClient,
            eventLoop: eventLoop
        )
        
        /// Set the projectId to use for this client. In order of priority:
        /// - Environment Variable (GOOGLE_PROJECT_ID) 
        /// - Environment Variable (PROJECT_ID)
        /// - Service Account's projectID
        /// - `IAMServiceAccountCredentialsConfiguration` `project` property (optionally configured).
        /// - `GoogleCloudCredentialsConfiguration's` `project` property (optionally configured).
        
        guard let projectId = ProcessInfo.processInfo.environment["GOOGLE_PROJECT_ID"] ??
                              ProcessInfo.processInfo.environment["PROJECT_ID"] ??
                              (refreshableToken as? OAuthServiceAccount)?.credentials.projectId ??
                              config.project ?? credentials.project 
        else {
            throw IAMServiceAccountCredentialsError.projectIdMissing
        }
        
        request = IAMServiceAccountCredentialsRequest(
            httpClient: httpClient,
            eventLoop: eventLoop,
            oauth: refreshableToken,
            project: projectId
        )
        
        api = GoogleCloudServiceAccountCredentialsAPI(
            request: request,
            endpoint: base
        )
    }
    
    /// Hop to a new eventloop to execute requests on.
    /// - Parameter eventLoop: The eventloop to execute requests on.
    public func hopped(to eventLoop: EventLoop) -> IAMServiceAccountCredentialsClient {
        request.eventLoop = eventLoop
        return self
    }
}
