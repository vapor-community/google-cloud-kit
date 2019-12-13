//
//  OAuthComputeEngine+AppEngineFlex.swift
//  GoogleCloud
//
//  Created by Andrew Edwards on 11/15/18.
//

import NIO
import NIOFoundationCompat
import NIOHTTP1
import AsyncHTTPClient
import Foundation

/// [Reference](https://cloud.google.com/compute/docs/access/create-enable-service-accounts-for-instances#applications)
public class OAuthComputeEngineAppEngineFlex: OAuthRefreshable {
    let serviceAccount: String
    let httpClient: HTTPClient
    var serviceAccountTokenURL: String {
        "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/\(serviceAccount)/token"
    }
    private let decoder = JSONDecoder()
    private let eventLoop: EventLoop
    
    init(serviceAccount: String = "default", httpClient: HTTPClient, eventLoop: EventLoop) {
        self.serviceAccount = serviceAccount
        self.httpClient = httpClient
        self.eventLoop = eventLoop
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    public func refresh() -> EventLoopFuture<OAuthAccessToken> {
        do {
            let headers: HTTPHeaders = ["Metadata-Flavor": "Google"]
            let request = try HTTPClient.Request(url: serviceAccountTokenURL, method: .GET, headers: headers)
            
            return httpClient.execute(request: request, eventLoop: .delegate(on: self.eventLoop)).flatMap { response in
                
                guard var byteBuffer = response.body,
                    let responseData = byteBuffer.readData(length: byteBuffer.readableBytes),
                    response.status == .ok else {
                        return self.eventLoop.makeFailedFuture(OauthRefreshError.noResponse(response.status))
                }
                
                do {
                    return self.eventLoop.makeSucceededFuture(try self.decoder.decode(OAuthAccessToken.self, from: responseData))
                } catch {
                    return self.eventLoop.makeFailedFuture(error)
                }
            }
        } catch {
            return self.eventLoop.makeFailedFuture(error)
        }
    }
}
