import Core
import NIO
import AsyncHTTPClient
import Foundation

public protocol TopicsAPI {
    /// Gets the configuration of a topic.
    ///
    /// - parameter `topicId`: Name of the topic
    ///             `topicProject`: Name of the project that owns the topic. If not provided, the default project will be used.
    /// - returns: If successful, the response body contains an instance of `Topic`.
    func get(topicId: String, topicProject: String?) -> EventLoopFuture<GoogleCloudPubSubTopic>
    
    /// Lists matching topics.
    ///
    /// - parameter `pageSize`: Maximum number of topics to return.
    ///             `pageToken`: The value returned by the last ListTopicsResponse; indicates that this is a
    ///             continuation of a prior topics.list call, and that the system should return the next page of data
    ///             `topicProject`: Name of the project that owns the topic. If not provided, the default project will be used.
    /// - returns: Returns a list of topics and the `nextPageToken`
    func list(pageSize: Int?, pageToken: String?, topicProject: String?) -> EventLoopFuture<GooglePubSubListTopicResponse>
    
    /// Adds one or more messages to the topic.
    ///
    /// - parameter `topicId`: Name of the topic
    ///             `topicProject`: Name of the project that owns the topic. If not provided, the default project will be used.
    ///             `data`: Data to be passed in the message
    ///             `attributes`: Attributes for this message
    ///             `orderingKey`: Identifies related messages for which publish order should be respected
    /// - returns: Returns an array of `messageId`. `MessageId` is the server-assigned ID of each published message, in the same order as the messages in the request. IDs are guaranteed to be unique within the topic.
    func publish(topicId: String, topicProject: String?, data: String, attributes: [String: String]?, orderingKey: String?) -> EventLoopFuture<GoogleCloudPublishResponse>
    
    /// Lists the names of the attached subscriptions on this topic.
    func getSubscriptionsList(topicId: String, topicProject: String?, pageSize: Int?, pageToken: String?) -> EventLoopFuture<GooglePubSubTopicSubscriptionListResponse>
}

public final class GoogleCloudPubSubTopicsAPI: TopicsAPI {
    let endpoint: String
    let request: GoogleCloudPubSubRequest
    let encoder = JSONEncoder()
    
    init(request: GoogleCloudPubSubRequest,
         endpoint: String) {
        self.request = request
        self.endpoint = endpoint
    }
    
    public func get(topicId: String, topicProject: String? = nil) -> EventLoopFuture<GoogleCloudPubSubTopic> {
        return request.send(method: .GET, path: "\(endpoint)/v1/projects/\(topicProject ?? request.project)/topics/\(topicId)")
    }
    
    public func list(pageSize: Int?, pageToken: String?, topicProject: String? = nil) -> EventLoopFuture<GooglePubSubListTopicResponse> {
        var query = "pageSize=\(pageSize ?? 10)"
        if let pageToken = pageToken {
            query.append(contentsOf: "&pageToken=\(pageToken)")
        }
        
        return request.send(method: .GET,
                            path: "\(endpoint)/v1/projects/\(topicProject ?? request.project)/topics",
                            query: query)
    }
    
    public func publish(topicId: String, topicProject: String? = nil, data: String, attributes: [String: String]?, orderingKey: String?) -> EventLoopFuture<GoogleCloudPublishResponse> {
        do {
            let message = GoogleCloudPubSubMessage(data: data, attributes: attributes, orderingKey: orderingKey)
            let publishRequest = GoogleCloudPublishRequest(messages: [message])
            let body = try HTTPClient.Body.data(encoder.encode(publishRequest))
            let path = "\(endpoint)/v1/projects/\(topicProject ?? request.project)/topics/\(topicId):publish"
            
            print("<<<--- Publish on: \(path) --->")
            
            return request.send(method: .POST,
                                path: path,
                                body: body)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func getSubscriptionsList(topicId: String, topicProject: String? = nil, pageSize: Int?, pageToken: String?) -> EventLoopFuture<GooglePubSubTopicSubscriptionListResponse> {
        var query = "pageSize=\(pageSize ?? 10)"
        if let pageToken = pageToken {
            query.append(contentsOf: "&pageToken=\(pageToken)")
        }
        
        return request.send(method: .GET,
                            path: "\(endpoint)/v1/projects/\(topicProject ?? request.project)/topics/subscriptions",
                            query: query)
    }
}
