//
//  PubSubMessage.swift
//  
//
//  Created by Susheel Athmakuri on 6/20/21.
//

import Core
import Foundation

public struct GoogleCloudPubSubMessage: GoogleCloudModel {
    public var data: String?
    public var attributes: [String: String]?
    public var messageId: String?
    public var publishTime: String?
    public var orderingKey: String?
}
