import Core
import Foundation
import AsyncHTTPClient
import NIO

public final class GoogleCloudPubSubClient {
    public var pubSubTopic: TopicAPI
    var pubSubRequest: GoogleCloudPubSubRequest
    
    public init(credentials: GoogleCloudCredentialsConfiguration,
                config: GoogleCloudPubSubConfiguration,
                httpClient: HTTPClient,
                eventLoop: EventLoop,
                base: String = "https://pubsub.googleapis.com") throws {
        let refreshableToken = OAuthCredentialLoader.getRefreshableToken(credentials: credentials,
                                                                         withConfig: config,
                                                                         andClient: httpClient,
                                                                         eventLoop: eventLoop)
        guard let projectId = ProcessInfo.processInfo.environment["PROJECT_ID"] ??
                              (refreshableToken as? OAuthServiceAccount)?.credentials.projectId ??
                              config.project ?? credentials.project else {
            throw GoogleCloudPubSubError.projectIdMissing
        }
        
        pubSubRequest = GoogleCloudPubSubRequest(httpClient: httpClient,
                                                 eventLoop: eventLoop,
                                                 oauth: refreshableToken,
                                                 project: projectId)
        pubSubTopic = GoogleCloudPubSubTopicAPI(request: pubSubRequest, endpoint: base)
        
    }
    
    /// Hop to a new eventloop to execute requests on.
    /// - Parameter eventLoop: The eventloop to execute requests on.
    public func hopped(to eventLoop: EventLoop) -> GoogleCloudPubSubClient {
        pubSubRequest.eventLoop = eventLoop
        return self
    }
}
