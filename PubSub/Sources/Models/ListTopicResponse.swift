//
//  ListTopicResponse.swift
//  
//
//  Created by Susheel Athmakuri on 6/20/21.
//

import Core
import Foundation

public struct GooglePubSubListTopicResponse: GoogleCloudModel {
    public var topics: [GoogleCloudPubSubTopic]
    public var nextPageToken: String?
}
