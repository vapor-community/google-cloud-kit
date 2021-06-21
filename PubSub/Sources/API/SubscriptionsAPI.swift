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
    func create(subscriptionId: String, topicId: String, pushConfig: PushConfig?, ackDeadlineSeconds: Int?, retainAckedMessages: Bool?, messageRetentionDuration: String?, labels: [String: String]?, enableMessageOrdering: Bool?, expirationPolicy: ExpirationPolicy?, filter: String?, deadLetterPolicy: DeadLetterPolicy?, retryPolicy: RetryPolicy?, detached: Bool?) -> EventLoopFuture<GoogleCloudPubSubSubscription>
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
    
    public func create(subscriptionId: String, topicId: String, pushConfig: PushConfig?, ackDeadlineSeconds: Int?, retainAckedMessages: Bool?, messageRetentionDuration: String?, labels: [String : String]?, enableMessageOrdering: Bool?, expirationPolicy: ExpirationPolicy?, filter: String?, deadLetterPolicy: DeadLetterPolicy?, retryPolicy: RetryPolicy?, detached: Bool?) -> EventLoopFuture<GoogleCloudPubSubSubscription> {
        do {
            let subscription = GoogleCloudPubSubSubscription(name: subscriptionId,
                                                             topic: topicId,
                                                             pushConfig: pushConfig,
                                                             ackDeadlineSeconds: ackDeadlineSeconds,
                                                             retainAckedMessages: retainAckedMessages,
                                                             messageRetentionDuration: messageRetentionDuration,
                                                             labels: labels,
                                                             enableMessageOrdering: enableMessageOrdering,
                                                             expirationPolicy: expirationPolicy, filter: filter,
                                                             deadLetterPolicy: deadLetterPolicy,
                                                             retryPolicy: retryPolicy,
                                                             detached: detached)
            let body = try HTTPClient.Body.data(encoder.encode(subscription))
            return request.send(method: .PUT,
                                path: "\(endpoint)/v1/projects/\(request.project)/subscriptions/\(subscriptionId)",
                                body: body)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
}
