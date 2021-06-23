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
    func create(subscriptionId: String,
                topicId: String,
                pushEndpoint: String?,
                pushConfigAttributes: [String: String]?,
                pushConfigOidcTokenServiceAccountEmail: String?,
                pushConfigOidcTokenAudience: String?,
                ackDeadlineSeconds: Int?,
                retainAckedMessages: Bool?,
                messageRetentionDuration: String?,
                labels: [String: String]?,
                enableMessageOrdering: Bool?,
                expirationPolicyTTL: String?,
                filter: String?,
                deadLetterPolicyTopic: String?,
                deadLetterPolicyMaxDeliveryAttempts: Int?,
                retryPolicyMinimumBackoff: String?,
                retryPolicyMaximumBackoff: String?,
                detached: Bool?) -> EventLoopFuture<GoogleCloudPubSubSubscription>
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
    
    public func create(subscriptionId: String,
                       topicId: String,
                       pushEndpoint: String?,
                       pushConfigAttributes: [String: String]?,
                       pushConfigOidcTokenServiceAccountEmail: String?,
                       pushConfigOidcTokenAudience: String?,
                       ackDeadlineSeconds: Int?,
                       retainAckedMessages: Bool?,
                       messageRetentionDuration: String?,
                       labels: [String: String]?,
                       enableMessageOrdering: Bool?,
                       expirationPolicyTTL: String?,
                       filter: String?,
                       deadLetterPolicyTopic: String?,
                       deadLetterPolicyMaxDeliveryAttempts: Int?,
                       retryPolicyMinimumBackoff: String?,
                       retryPolicyMaximumBackoff: String?,
                       detached: Bool?) -> EventLoopFuture<GoogleCloudPubSubSubscription> {
        do {
            var pushConfig: PushConfig? = nil
            if let pushEndpoint = pushEndpoint {
                var oidcToken: OidcToken? = nil
                if let serviceAccountEmail = pushConfigOidcTokenServiceAccountEmail, let audience = pushConfigOidcTokenAudience {
                    oidcToken = OidcToken(serviceAccountEmail: serviceAccountEmail, audience: audience)
                }
                
                pushConfig = PushConfig(pushEndpoint: pushEndpoint,
                                            attributes: pushConfigAttributes,
                                            oidcToken: oidcToken)
            }
            
            var expirationPolicy: ExpirationPolicy? = nil
            if let ttl = expirationPolicyTTL {
                expirationPolicy = ExpirationPolicy(ttl: ttl)
            }
            
            var deadLetterPolicy: DeadLetterPolicy? = nil
            if let deadLetterPolicyTopic = deadLetterPolicyTopic {
                deadLetterPolicy = DeadLetterPolicy(deadLetterTopic: deadLetterPolicyTopic,
                                                        maxDeliveryAttempts: deadLetterPolicyMaxDeliveryAttempts)
            }
            
            var retryPolicy: RetryPolicy? = nil
            if let min = retryPolicyMinimumBackoff, let max = retryPolicyMaximumBackoff {
                retryPolicy = RetryPolicy(minimumBackoff: min,
                                          maximumBackoff: max)
            }
            
            let subscription = GoogleCloudPubSubSubscription(name: subscriptionId,
                                                             topic: "projects/\(request.project)/topics/\(topicId)",
                                                             pushConfig: pushConfig,
                                                             ackDeadlineSeconds: ackDeadlineSeconds,
                                                             retainAckedMessages: retainAckedMessages,
                                                             messageRetentionDuration: messageRetentionDuration,
                                                             labels: labels,
                                                             enableMessageOrdering: enableMessageOrdering,
                                                             expirationPolicy: expirationPolicy,
                                                             filter: filter,
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
