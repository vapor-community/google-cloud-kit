import Core
import NIO
import AsyncHTTPClient
import Foundation

public protocol PubSubAPI {
    func dummy() -> EventLoopFuture<PubSubResponse>
}

public final class GoogleCloudPubSubAPI: PubSubAPI {
    let endpoint: String
    let request: GoogleCloudTranslationRequest
    let encoder = JSONEncoder()
    
    init(request: GoogleCloudTranslationRequest,
         endpoint: String) {
        self.request = request
        self.endpoint = endpoint
    }
    
    private var publisherPath: String {
        "\(endpoint)/language/translate/v2"
    }
    
    public func dummy() -> EventLoopFuture<PubSubResponse> {
        let response = PubSubResponse(dummy: "")
        return request.eventLoop.makeSuccessfulFuture(response)
    }
}
