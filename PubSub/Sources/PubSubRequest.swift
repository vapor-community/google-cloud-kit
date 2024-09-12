import Foundation
import Core
import NIO
import NIOFoundationCompat
import NIOHTTP1
import AsyncHTTPClient

class GoogleCloudPubSubRequest: GoogleCloudAPIRequest {
    let refreshableToken: OAuthRefreshable
    let project: String
    let httpClient: HTTPClient
    let responseDecoder: JSONDecoder = JSONDecoder()
    var currentToken: OAuthAccessToken?
    var tokenCreatedTime: Date?
    var eventLoop: EventLoop
    
    init(httpClient: HTTPClient, eventLoop: EventLoop, oauth: OAuthRefreshable, project: String) {
        self.refreshableToken = oauth
        self.project = project
        self.httpClient = httpClient
        self.eventLoop = eventLoop
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        self.responseDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    public func send<GCM: GoogleCloudModel>(method: HTTPMethod, headers: HTTPHeaders = [:], path: String, query: String? = nil, body: HTTPClient.Body = .data(Data())) -> EventLoopFuture<GCM> {
        return withToken { token in
            return self._send(method: method, headers: headers, path: path, query: query, body: body, accessToken: token.accessToken).flatMap { response in
                do {
                    let model = try self.responseDecoder.decode(GCM.self, from: response)
                    return self.eventLoop.makeSucceededFuture(model)
                } catch {
                    return self.eventLoop.makeFailedFuture(error)
                }
            }
        }
    }

    private func _send(method: HTTPMethod, headers: HTTPHeaders, path: String, query: String?, body: HTTPClient.Body, accessToken: String) -> EventLoopFuture<Data> {
        var _headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)",
                                     "Content-Type": "application/json"]
        headers.forEach { _headers.replaceOrAdd(name: $0.name, value: $0.value) }

        do {
            var url = "\(path)"
            if let query = query {
                url.append("?\(query)")
            }
            print("<<<--- Publish on URL: \(url) --->")
            let request = try HTTPClient.Request(url: url, method: method, headers: _headers, body: body)

            return httpClient.execute(request: request, eventLoop: .delegate(on: self.eventLoop)).flatMap { response in

                guard var byteBuffer = response.body else {
                    fatalError("Response body from Google is missing! This should never happen.")
                }
                let responseData = byteBuffer.readData(length: byteBuffer.readableBytes)!

                guard (200...299).contains(response.status.code) else {
                    let error: Error
                    if let jsonError = try? self.responseDecoder.decode(PubSubAPIError.self, from: responseData) {
                        error = jsonError
                    } else {
                        let body = response.body?.getString(at: response.body?.readerIndex ?? 0, length: response.body?.readableBytes ?? 0) ?? ""
                        error = PubSubAPIError(error: PubSubAPIErrorBody(status: "unknownError", code: Int(response.status.code), message: body))
                    }

                    return self.eventLoop.makeFailedFuture(error)
                }
                return self.eventLoop.makeSucceededFuture(responseData)
            }
        } catch {
            return self.eventLoop.makeFailedFuture(error)
        }
    }
}
