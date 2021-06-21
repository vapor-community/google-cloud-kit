//
//  Subscription.swift
//  
//
//  Created by Susheel Athmakuri on 6/21/21.
//

import Core
import Foundation

public struct GoogleCloudPubSubSubscription: GoogleCloudModel {
    public var name: String
    public var topic: String
    public var pushConfig: PushConfig?
    public var ackDeadlineSeconds: Int?
    public var retainAckedMessages: Bool?
    public var messageRetentionDuration: String?
    public var labels: [String: String]?
    public var enableMessageOrdering: Bool?
    public var expirationPolicy: ExpirationPolicy?
    public var filter: String?
    public var deadLetterPolicy: DeadLetterPolicy?
    public var retryPolicy: RetryPolicy?
    public var detached: Bool?
}

public struct PushConfig: GoogleCloudModel {
    public var pushEndpoint: String
    public var attributes: [String: String]?
    public var oidcToken: OidcToken?
}

public struct ExpirationPolicy: GoogleCloudModel {
    public var ttl: String
}

public struct DeadLetterPolicy: GoogleCloudModel {
    public var deadLetterTopic: String
    public var maxDeliveryAttempts: Int
}

public struct RetryPolicy: GoogleCloudModel {
    public var minimumBackoff: String
    public var maximumBackoff: String
}

public struct OidcToken: GoogleCloudModel {
    public var serviceAccountEmail: String?
    public var audience: String?
}

public struct EmptyResponse: GoogleCloudModel {}
