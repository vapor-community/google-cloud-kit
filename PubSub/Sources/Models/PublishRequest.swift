//
//  PublishRequest.swift
//  
//
//  Created by Susheel Athmakuri on 6/21/21.
//

import Core
import Foundation

public struct GoogleCloudPublishRequest: GoogleCloudModel {
    public let messages: [GoogleCloudPubSubMessage]
}
