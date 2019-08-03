//
//  ChannelsAPI.swift
//  GoogleCloudProvider
//
//  Created by Andrew Edwards on 5/19/18.
//

import Vapor

public protocol ChannelsAPI {
    func stop(channelId: String, resourceId: String, queryParameters: [String: String]?) throws -> Future<EmptyResponse>
}

extension ChannelsAPI {
    public func stop(channelId: String, resourceId: String, queryParameters: [String: String]? = nil) throws -> Future<EmptyResponse> {
        return try stop(channelId: channelId, resourceId: resourceId, queryParameters: queryParameters)
    }
}

public final class GoogleChannelsAPI: ChannelsAPI {
    let endpoint = "https://www.googleapis.com/storage/v1/channels"
    let request: GoogleCloudStorageRequest
    
    init(request: GoogleCloudStorageRequest) {
        self.request = request
    }
    
    /// Stop receiving object change notifications through this channel.
    public func stop(channelId: String, resourceId: String, queryParameters: [String: String]?) throws -> Future<EmptyResponse> {
        var queryParams = ""
        if let queryParameters = queryParameters {
            queryParams = queryParameters.queryParameters
        }
        
        let requestBody = try JSONEncoder().encode(["id": channelId, "resourceid": resourceId]).convertToHTTPBody()
        
        return try request.send(method: .POST, path: "\(endpoint)/stop)", query: queryParams, body: requestBody)
    }
}
