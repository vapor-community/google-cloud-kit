//
//  ListTopicResponse.swift
//  
//
//  Created by Susheel Athmakuri on 6/20/21.
//

import Core
import Foundation

public struct GooglePubSubListTopicResponse: GoogleCloudModel {
    /// The resulting topics.
    public var topics: [GoogleCloudPubSubTopic]
    
    /// If not empty, indicates that there may be more topics that match the request; this value should be passed in a new ListTopicsRequest.
    public var nextPageToken: String?
}
