//
//  Topic.swift
//  
//
//  Created by Susheel Athmakuri on 6/19/21.
//

import Core
import Foundation

public struct GoogleCloudPubSubTopic: GoogleCloudModel {
    /// Reserved for future use. This field is set only in responses from the server; it is ignored if it is set in any requests.
    public var name: String
    
    /// See [Creating and managing labels] (https://cloud.google.com/pubsub/docs/labels).
    public var labels: [String: String]
    
    /// A policy constraining the storage of messages published to the topic.
    public var messageStoragePolicy: MessageStoragePolicy
    
    /// The resource name of the Cloud KMS CryptoKey to be used to protect access to messages published on this topic. The expected format is `projects/*/locations/*/keyRings/*/cryptoKeys/*`.
    public var kmsKeyName: String
    
    /// Settings for validating messages published against a schema.
    public var schemaSettings: SchemaSettings
    
    /// Reserved for future use. This field is set only in responses from the server; it is ignored if it is set in any requests.
    public var satisfiesPzs: Bool
}

public struct MessageStoragePolicy: GoogleCloudModel {
    /// A policy constraining the storage of messages published to the topic.
    public var allowedPersistenceRegions: [String]
}

public struct SchemaSettings: GoogleCloudModel {
    /// Required. The name of the schema that messages published should be validated against. Format is `projects/{project}/schemas/{schema}`. The value of this field will be `_deleted-schema_` if the schema has been deleted.
    public var schema: String
    
    /// The encoding of messages validated against `schema`.
    public var encoding: GoogleCloudPubSubEncoding
}

public enum GoogleCloudPubSubEncoding {
    /// Unspecified
    case unspecified = "ENCODING_UNSPECIFIED"
    
    /// JSON encoding
    case json = "JSON"
    
    /// The encoding of messages validated against `schema`.
    case binary = "BINARY"
}
