import Core
import NIO
import AsyncHTTPClient
import Foundation

public protocol TopicsAPI {
    func get(topicId: String) -> EventLoopFuture<GoogleCloudPubSubTopic>
    func list(pageSize: Int?, pageToken: String?) -> EventLoopFuture<GooglePubSubListTopicResponse>
    func publish(topicId: String, data: String, attributes: [String: String]?, orderingKey: String?) -> EventLoopFuture<GoogleCloudPublishResponse>
    func getSubscriptionsList(topicId: String, pageSize: Int?, pageToken: String?) -> EventLoopFuture<GooglePubSubTopicSubscriptionListResponse>
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
    
    public func get(topicId: String) -> EventLoopFuture<GoogleCloudPubSubTopic> {
        return request.send(method: .GET, path: "\(endpoint)/v1/projects/\(request.project)/topics/\(topicId)")
    }
    
    public func list(pageSize: Int?, pageToken: String?) -> EventLoopFuture<GooglePubSubListTopicResponse> {
        var query = "pageSize=\(pageSize ?? 10)"
        if let pageToken = pageToken {
            query.append(contentsOf: "&pageToken=\(pageToken)")
        }
        
        return request.send(method: .GET,
                            path: "\(endpoint)/v1/projects/\(request.project)/topics",
                            query: query)
    }
    
    public func publish(topicId: String, data: String, attributes: [String: String]?, orderingKey: String?) -> EventLoopFuture<GoogleCloudPublishResponse> {
        do {
            let message = GoogleCloudPubSubMessage(data: data, attributes: attributes, orderingKey: orderingKey)
            let publishRequest = GoogleCloudPublishRequest(messages: [message])
            let body = try HTTPClient.Body.data(encoder.encode(publishRequest))
            let path = "\(endpoint)/v1/projects/\(request.project)/topics/\(topicId):publish"
            
            print("<<<--- Publish on: \(path) --->")
            
            return request.send(method: .POST,
                                path: path,
                                body: body)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func getSubscriptionsList(topicId: String, pageSize: Int?, pageToken: String?) -> EventLoopFuture<GooglePubSubTopicSubscriptionListResponse> {
        var query = "pageSize=\(pageSize ?? 10)"
        if let pageToken = pageToken {
            query.append(contentsOf: "&pageToken=\(pageToken)")
        }
        
        return request.send(method: .GET,
                            path: "\(endpoint)/v1/projects/\(request.project)/topics/subscriptions",
                            query: query)
    }
}
