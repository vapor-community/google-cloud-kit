//
//  ChannelsAPI.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 5/19/18.
//

import NIO
import NIOHTTP1
import Foundation

public protocol ChannelsAPI {
    
    /// Stop receiving object change notifications through this channel.
    /// - Parameter id: A UUID or similar unique string that identifies this channel.
    /// - Parameter resourceId: An opaque ID that identifies the resource being watched on this channel. Stable across different API versions.
    /// - Parameter queryParameters: Optional query parameters
    func stop(id: String, resourceId: String, queryParameters: [String: String]?) async throws -> EmptyResponse
}

extension ChannelsAPI {
    public func stop(
        id: String,
        resourceId: String,
        queryParameters: [String: String]? = nil
    ) async throws -> EmptyResponse {
        try await stop(id: id, resourceId: resourceId, queryParameters: queryParameters)
    }
}

public final class GoogleCloudStorageChannelsAPI: ChannelsAPI {
    let endpoint = "https://www.googleapis.com/storage/v1/channels"
    let request: GoogleCloudStorageRequest
    
    init(request: GoogleCloudStorageRequest) {
        self.request = request
    }
    
    public func stop(
        id: String,
        resourceId: String,
        queryParameters: [String: String]?
    ) async throws -> EmptyResponse {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        let body: [String: Any] = ["id": id, "resourceid": resourceId]
        let requestBody = try JSONSerialization.data(withJSONObject: body)
        return try await request.send(method: .POST,
                                      path: "\(endpoint)/stop)",
                                      query: queryParams,
                                      body: .bytes(.init(data: requestBody)))
    }
}
