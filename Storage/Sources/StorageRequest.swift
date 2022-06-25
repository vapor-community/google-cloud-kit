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

struct GoogleCloudStorageRequest: GoogleCloudAPIClient {
    let tokenProvider: AccessTokenProvider
    let httpClient: HTTPClient
    let decoder: JSONDecoder
    let project: String
    
    init(
        tokenProvider: AccessTokenProvider,
        client: HTTPClient,
        project: String
    ) {
        self.tokenProvider = tokenProvider
        self.httpClient = client
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        self.project = project
    }
    
    func send<T: Codable>(
        method: HTTPMethod,
        headers: HTTPHeaders = [:],
        path: String,
        query: String = "",
        body: HTTPClientRequest.Body = .bytes(.init(data: .init()))
    ) async throws -> T {
        let accessToken = try await tokenProvider.getAccessToken()
        var _headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)",
                                     "Content-Type": "application/json"]
        headers.forEach { _headers.replaceOrAdd(name: $0.name, value: $0.value) }
        
        var request = HTTPClientRequest(url: "\(path)?\(query)")
        request.headers = _headers
        request.method = method
        request.body = body
        
        let response = try await httpClient.execute(request, timeout: .seconds(60))
        let responseData = try await response.body.collect(upTo: 1024 * 1024 * 100) // 500mb to account for data downloads.
        
        guard (200...299).contains(response.status.code) else {
            do {
                throw try decoder.decode(CloudStorageAPIError.self, from: responseData)
            } catch {
                throw CloudStorageAPIError(error: CloudStorageAPIErrorBody(errors: [],
                                                                           code: Int(response.status.code),
                                                                           message: "An unexpected error occured"))
            }
        }
        
        if T.self is GoogleCloudStorgeDataResponse.Type {
            return GoogleCloudStorgeDataResponse(data: Data(buffer: responseData)) as! T
        } else {
            return try decoder.decode(T.self, from: Data(buffer: responseData))
        }
    }
}
