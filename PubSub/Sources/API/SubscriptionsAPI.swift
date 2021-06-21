//
//  SubscriptionsAPI.swift
//  
//
//  Created by Susheel Athmakuri on 6/21/21.
//

import Core
import NIO
import AsyncHTTPClient
import Foundation

public protocol SubscriptionsAPI {
    func get(subscriptionId: String) -> EventLoopFuture<GoogleCloudPubSubSubscription>
    func acknowledge(subscriptionId: String, ackIds: [String]) -> EventLoopFuture<EmptyResponse>
}

public final class GoogleCloudPubSubSubscriptionsAPI: SubscriptionsAPI {
    let endpoint: String
    let request: GoogleCloudPubSubRequest
    let encoder = JSONEncoder()
    
    init(request: GoogleCloudPubSubRequest, endpoint: String) {
        self.request = request
        self.endpoint = endpoint
    }
    
    public func get(subscriptionId: String) -> EventLoopFuture<GoogleCloudPubSubSubscription> {
        return request.send(method: .GET, path: "\(endpoint)/v1/projects/\(request.project)/subscriptions/\(subscriptionId)")
    }
    
    public func acknowledge(subscriptionId: String, ackIds: [String]) -> EventLoopFuture<EmptyResponse> {
        do {
            let acks = AcknowledgeRequest(ackIds: ackIds)
            let body = try HTTPClient.Body.data(encoder.encode(acks))
            return request.send(method: .POST,
                                path: "\(endpoint)/v1/projects/\(request.project)/subscriptions/\(subscriptionId):acknowledge",
                                body: body)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
}
