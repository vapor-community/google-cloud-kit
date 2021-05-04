import AsyncHTTPClient
import NIO
import Core
import Foundation

public protocol TranslationAPI {
    func translate(text: String, source: String?, target: String) -> EventLoopFuture<TranslationResponse>
}

public extension TranslationAPI {
    func translate(text: String, source: String? = nil, target: String) -> EventLoopFuture<TranslationResponse> {
        translate(text: text, source: source, target: target)
    }
}

public final class GoogleCloudTranslationAPI: TranslationAPI {
    
    let endpoint: String
    let request: GoogleCloudTranslationRequest
    let encoder = JSONEncoder()
    
    init(request: GoogleCloudTranslationRequest,
         endpoint: String) {
        self.request = request
        self.endpoint = endpoint
    }
    
    private var translationPath: String {
        "\(endpoint)/language/translate/v2"
    }

    public func translate(text: String, source: String? = nil, target: String) -> EventLoopFuture<TranslationResponse> {
        do {
            var bodyDict = [
                "q": text,
                "target": target,
                "format": "text"
            ]
            if let source = source {
                bodyDict["source"] = source
            }
            let body = try HTTPClient.Body.data(encoder.encode(bodyDict))
            return request.send(method: .POST, path: translationPath, body: body)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
}
