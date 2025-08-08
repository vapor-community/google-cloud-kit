import Core
import Foundation
import AsyncHTTPClient
import NIO

public final class GoogleCloudIdentityToolkitClient {

    public var account: AccountsAPI
    var identityToolkitRequest: GoogleCloudIdentityToolkitRequest
    
    /// Initialize a client for interacting with the Google Cloud Identity Toolkit API
    /// - Parameter credentials: The Credentials to use when authenticating with the APIs
    /// - Parameter httpClient: An `HTTPClient` used for making API requests
    /// - Parameter eventLoop: The EventLoop used to perform the work on
    /// - Parameter base: The base URL to use for the Identity Toolkit API
    public init(credentials: GoogleCloudCredentialsConfiguration,
                config: GoogleCloudIdentityToolkitConfiguration,
                httpClient: HTTPClient,
                eventLoop: EventLoop,
                base: String = "https://identitytoolkit.googleapis.com") throws {
        
        // Get OAuth token for authentication
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
        /// - `GoogleCloudDatastoreConfigurations` `project` property (optionally configured).
        /// - `GoogleCloudCredentialsConfiguration's` `project` property (optionally configured).
        
        guard let projectId = ProcessInfo.processInfo.environment["GOOGLE_PROJECT_ID"] ??
                              ProcessInfo.processInfo.environment["PROJECT_ID"] ??
                              (refreshableToken as? OAuthServiceAccount)?.credentials.projectId ??
                              config.project ?? credentials.project else {
            throw GoogleCloudIdentityToolkitError.projectIdMissing
        }

        guard let apiKey = ProcessInfo.processInfo.environment["GOOGLE_API_KEY"] ??
                          ProcessInfo.processInfo.environment["API_KEY"] else {
            throw GoogleCloudIdentityToolkitError.apiKeyMissing
        }
        
        identityToolkitRequest = GoogleCloudIdentityToolkitRequest(
            httpClient: httpClient,
            eventLoop: eventLoop,
            oauth: refreshableToken,
            project: projectId,
            apiKey: apiKey
        )
        
        account = GoogleCloudIdentityToolkitAccountsAPI(request: identityToolkitRequest, endpoint: base)
    }

    public func hopped(to eventLoop: EventLoop) -> GoogleCloudIdentityToolkitClient {
        identityToolkitRequest.eventLoop = eventLoop
        return self
    }
}
