//
//  TopicSubscriptionListResponse.swift
//  
//
//  Created by Susheel Athmakuri on 6/21/21.
//

import Core
import Foundation

public struct GooglePubSubTopicSubscriptionListResponse: GoogleCloudModel {
    /// The names of subscriptions attached to the topic specified in the request.
    public let subscriptions: [String]
    
    /// If not empty, indicates that there may be more subscriptions that match the request; this value should be passed in a new ListTopicSubscriptionsRequest to get more subscriptions.
    public let nextPageToken: String?
}
