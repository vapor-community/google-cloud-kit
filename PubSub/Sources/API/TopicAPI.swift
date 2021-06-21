import Core
import NIO
import AsyncHTTPClient
import Foundation

public protocol TopicAPI {
    func get(topic: String) -> EventLoopFuture<GoogleCloudPubSubTopic>
}

public final class GoogleCloudPubSubTopicAPI: TopicAPI {
    let endpoint: String
    let request: GoogleCloudPubSubRequest
    let encoder = JSONEncoder()
    
    init(request: GoogleCloudPubSubRequest,
         endpoint: String) {
        self.request = request
        self.endpoint = endpoint
    }
    
    public func get(topic: String) -> EventLoopFuture<GoogleCloudPubSubTopic> {
        return request.send(method: .GET, path: "\(endpoint)/v1/projects/\(request.project)/topics/\(topic)")
    }
}
