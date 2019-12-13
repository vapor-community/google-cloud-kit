//
//  StorageRequest.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 5/19/18.
//

import Core
import Foundation
import NIO
import NIOFoundationCompat
import NIOHTTP1
import AsyncHTTPClient

public final class GoogleCloudStorageRequest: GoogleCloudAPIRequest {
    
    public let refreshableToken: OAuthRefreshable
    public let project: String
    public let httpClient: HTTPClient
    public let responseDecoder: JSONDecoder = JSONDecoder()
    public var currentToken: OAuthAccessToken?
    public var tokenCreatedTime: Date?
    private let eventLoop: EventLoop
    
    init(httpClient: HTTPClient, eventLoop: EventLoop, oauth: OAuthRefreshable, project: String) {
        self.refreshableToken = oauth
        self.httpClient = httpClient
        self.project = project
        self.eventLoop = eventLoop
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        self.responseDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    public func send<GCM: GoogleCloudModel>(method: HTTPMethod, headers: HTTPHeaders = [:], path: String, query: String = "", body: HTTPClient.Body = .data(Data())) -> EventLoopFuture<GCM> {
        return withToken { token in
            return self._send(method: method, headers: headers, path: path, query: query, body: body, accessToken: token.accessToken).flatMap { response in
                do {
                    if GCM.self is GoogleCloudStorgeDataResponse.Type {
                        let model = GoogleCloudStorgeDataResponse(data: response) as! GCM
                        return self.eventLoop.makeSucceededFuture(model)
                    } else {
                        let model = try self.responseDecoder.decode(GCM.self, from: response)
                        return self.eventLoop.makeSucceededFuture(model)
                    }
                } catch {
                    return self.eventLoop.makeFailedFuture(error)
                }
            }
        }
    }
    
    private func _send(method: HTTPMethod, headers: HTTPHeaders, path: String, query: String, body: HTTPClient.Body, accessToken: String) -> EventLoopFuture<Data> {
        var _headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)",
                                     "Content-Type": "application/json"]
        headers.forEach { _headers.replaceOrAdd(name: $0.name, value: $0.value) }

        do {
            let request = try HTTPClient.Request(url: "\(path)?\(query)", method: method, headers: _headers, body: body)
            
            return httpClient.execute(request: request, eventLoop: .delegate(on: self.eventLoop)).flatMap { response in
                // If we get a 204 for example in the delete api call just return an empty body to decode.
                // https://cloud.google.com/s/results/?q=If+successful%2C+this+method+returns+an+empty+response+body.&p=%2Fstorage%2Fdocs%2F
                if response.status == .noContent {
                    return self.eventLoop.makeSucceededFuture("{}".data(using: .utf8)!)
                }

                guard var byteBuffer = response.body else {
                    fatalError("Response body from Google is missing! This should never happen.")
                }
                let responseData = byteBuffer.readData(length: byteBuffer.readableBytes)!

                guard (200...299).contains(response.status.code) else {
                    let error: Error
                    if let jsonError = try? self.responseDecoder.decode(CloudStorageAPIError.self, from: responseData) {
                        error = jsonError
                    } else {
                        let body = response.body?.getString(at: response.body?.readerIndex ?? 0, length: response.body?.readableBytes ?? 0) ?? ""
                        error = CloudStorageAPIError(error: CloudStorageAPIErrorBody(errors: [], code: Int(response.status.code), message: body))
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
