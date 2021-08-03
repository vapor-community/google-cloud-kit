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
    /// Gets the configuration details of a subscription.
    ///
    /// - parameter `subscriptionId`: The name of the subscription to get
    /// - returns: An instance of the `Subscription`
    func get(subscriptionId: String) -> EventLoopFuture<GoogleCloudPubSubSubscription>
    
    /// Acknowledges the messages associated with the ackIds in the AcknowledgeRequest.
    ///
    /// - parameters `subscriptionId`: ID of the subscription whose message is being acknowledged
    ///              `ackIds`: The acknowledgment ID for the messages being acknowledged that was returned by the Pub/Sub system in the subscriptions.pull response. Must not be empty.
    func acknowledge(subscriptionId: String, ackIds: [String]) -> EventLoopFuture<EmptyResponse>
    
    /// Creates a subscription to a given topic.
    /// - parameter `subscriptionId`: The name of the subscription to be created.
    ///             `topicId`: The name of the topic from which this subscription is receiving messages.
    ///             `pushEndpoint`: A URL locating the endpoint to which messages should be pushed.
    ///             `pushConfigAttributes`: Endpoint configuration attributes that can be used to control different aspects of the message delivery.
    ///             `pushConfigOidcTokenServiceAccountEmail`:Service account email to be used for generating the OIDC token.
    ///             `pushConfigOidcTokenAudience`: Audience to be used when generating OIDC token.
    ///             `ackDeadlineSeconds`: The approximate amount of time (on a best-effort basis) Pub/Sub waits for the subscriber to acknowledge receipt before resending the message
    ///             `retainAckedMessages`: Indicates whether to retain acknowledged messages.
    ///             `messageRetentionDuration`: How long to retain unacknowledged messages in the subscription's backlog, from the moment a message is published
    ///             `labels`: An object containing a list of "key": value pairs.
    ///             `enableMessageOrdering`: If true, messages published with the same orderingKey in PubsubMessage will be delivered to the subscribers in the order in which they are received by the Pub/Sub system. Otherwise, they may be delivered in any order.
    ///             `expirationPolicyTTL`: A policy that specifies the conditions for this subscription's expiration.
    ///             `filter`: An expression written in the Pub/Sub filter language.
    ///             `deadLetterPolicyTopic`: The name of the topic to which dead letter messages should be published.
    ///             `deadLetterPolicyMaxDeliveryAttempts`: The maximum number of delivery attempts for any message.
    ///             `retryPolicyMinimumBackoff`: The minimum delay between consecutive deliveries of a given message.
    ///             `retryPolicyMaximumBackoff`: The maximum delay between consecutive deliveries of a given message.
    ///             `detached`: Indicates whether the subscription is detached from its topic.
    ///
    /// - returns: If successful, the response body contains a newly created instance of Subscription.
    ///            If the subscription already exists, returns ALREADY_EXISTS. If the corresponding topic doesn't exist, returns NOT_FOUND.
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
