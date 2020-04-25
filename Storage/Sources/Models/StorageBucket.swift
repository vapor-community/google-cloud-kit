//
//  StorageBucket.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 4/17/18.
//

import Core
import Foundation

/// The Buckets resource represents a bucket in Google Cloud Storage. There is a single global namespace shared by all buckets. For more information, see Bucket Name Requirements.
public struct GoogleCloudStorageBucket: GoogleCloudModel {
    /// Access controls on the bucket, containing one or more bucketAccessControls Resources.
    public var acl: [BucketAccessControls]?
    /// The bucket's billing configuration.
    public var billing: Billing?
    /// The bucket's Cross-Origin Resource Sharing (CORS) configuration.
    public var cors: [Cors]?
    /// Whether or not to automatically apply an eventBasedHold to new objects added to the bucket.
    public var defaultEventBasedHold: Bool?
    /// Default access controls to apply to new objects when no ACL is provided.
    public var defaultObjectAcl: [ObjectAccessControls]?
    /// Encryption configuration for a bucket.
    public var encryption: Encryption?
    /// HTTP 1.1 Entity tag for the bucket.
    public var etag: String?
    /// The ID of the bucket. For buckets, the id and name properties are the same.
    public var id: String?
    /// The kind of item this is. For buckets, this is always storage#bucket.
    public var kind: String?
    /// User-provided labels, in key/value pairs.
    public var labels: [String: String]?
    /// The bucket's lifecycle configuration. See lifecycle management for more information.
    public var lifecycle: Lifecycle?
    /// The location of the bucket. Object data for objects in the bucket resides in physical storage within this region. Defaults to US.
    public var location: String?
    /// The bucket's logging configuration, which defines the destination bucket and optional name prefix for the current bucket's logs.
    public var logging: Logging?
    /// The metadata generation of this bucket.
    public var metageneration: String?
    /// The name of the bucket.
    public var name: String?
    /// The owner of the bucket. This is always the project team's owner group.
    public var owner: Owner?
    /// The project number of the project the bucket belongs to.
    public var projectNumber: String?
    /// The URI of this bucket.
    public var selfLink: String?
    /// The bucket's retention policy, which defines the minimum age an object in the bucket must reach before it can be deleted or overwritten.
    public var retentionPolicy: RetentionPolicy?
    /// The bucket's default storage class, used whenever no storageClass is specified for a newly-created object. This defines how objects in the bucket are stored and determines the SLA and the cost of storage. Values include `MULTI_REGIONAL`, `REGIONAL`, `STANDARD`, `NEARLINE`, `COLDLINE`, and `DURABLE_REDUCED_AVAILABILITY`. If this value is not specified when the bucket is created, it will default to `STANDARD`.
    public var storageClass: String?
    /// The creation time of the bucket in RFC 3339 format.
    public var timeCreated: Date?
    /// The modification time of the bucket in RFC 3339 format.
    public var updated: Date?
    /// The bucket's versioning configuration.
    public var versioning: Versioning?
    /// The bucket's website configuration, controlling how the service behaves when accessing bucket contents as a web site.
    public var website: Website?
}

public struct BucketAccessControls: GoogleCloudModel {
    /// The kind of item this is. For bucket access control entries, this is always storage#bucketAccessControl.
    public var kind: String?
    /// The ID of the access-control entry.
    public var id: String?
    /// The link to this access-control entry.
    public var selfLink: String?
    /// The name of the bucket.
    public var bucket: String?
    /// The entity holding the permission.
    public var entity: String?
    /// The access permission for the entity.
    public var role: String?
    /// The email address associated with the entity, if any.
    public var email: String?
    /// The ID for the entity, if any.
    public var entityId: String?
    /// The domain associated with the entity, if any.
    public var domain: String?
    /// The project team associated with the entity, if any.
    public var projectTeam: ProjectTeam?
    /// HTTP 1.1 Entity tag for the access-control entry.
    public var etag: String?
    
    public init(kind: String? = nil,
                id: String? = nil,
                selfLink: String? = nil,
                bucket: String? = nil,
                entity: String? = nil,
                role: String? = nil,
                email: String? = nil,
                entityId: String? = nil,
                domain: String? = nil,
                projectTeam: ProjectTeam? = nil,
                etag: String? = nil) {
        self.kind = kind
        self.id = id
        self.selfLink = selfLink
        self.bucket = bucket
        self.entity = entity
        self.role = role
        self.email = email
        self.entityId = entityId
        self.domain = domain
        self.projectTeam = projectTeam
        self.etag = etag
    }
}

public struct StorageNotification: GoogleCloudModel {
    /// The kind of item this is. For notifications, this is always storage#notification.
    public var kind: String?
    /// The ID of the notification.
    public var id: String?
    /// The canonical URL of this notification.
    public var selfLink: String?
    /// The Cloud PubSub topic to which this subscription publishes. Formatted as: '//pubsub.googleapis.com/projects/{project-identifier}/topics/{my-topic}'
    public var topic: String?
    /// If present, only send notifications about listed event types. If empty, sent notifications for all event types.
    public var eventTypes: [String]?
    /// An optional list of additional attributes to attach to each Cloud PubSub message published for this notification subscription.
    public var customAttributes: [String: String]?
    /// The desired content of the Payload. Acceptable values are: "JSON_API_V1" and "NONE".
    public var payloadFormat: String?
    /// If present, only apply this notification configuration to object names that begin with this prefix.
    public var objectNamePrefix: String?
    /// HTTP 1.1 Entity tag for this subscription notification.
    public var etag: String?
    
    public init(kind: String? = nil,
                id: String? = nil,
                selfLink: String? = nil,
                topic: String? = nil,
                eventTypes: [String]? = nil,
                customAttributes: [String: String]? = nil,
                payloadFormat: String? = nil,
                objectNamePrefix: String? = nil,
                etag: String? = nil) {
        self.kind = kind
        self.id = id
        self.selfLink = selfLink
        self.topic = topic
        self.eventTypes = eventTypes
        self.customAttributes = customAttributes
        self.payloadFormat = payloadFormat
        self.objectNamePrefix = objectNamePrefix
        self.etag = etag
    }
    
    public enum CodingKeys: String, CodingKey {
        case kind
        case id
        case selfLink
        case topic
        case eventTypes = "event_types"
        case customAttributes = "custom_attributes"
        case payloadFormat = "payload_format"
        case objectNamePrefix = "object_name_prefix"
        case etag
    }
}

public struct ObjectAccessControls: GoogleCloudModel {
    /// The kind of item this is. For object access control entries, this is always storage#objectAccessControl.
    public var kind: String?
    /// The ID of the access-control entry.
    public var id: String?
    /// The link to this access-control entry.
    public var selfLink: String?
    /// The name of the bucket.
    public var bucket: String?
    /// The name of the object, if applied to an object.
    public var object: String?
    /// The content generation of the object, if applied to an object.
    public var generation: String?
    /// The entity holding the permission.
    public var entity: String?
    /// The access permission for the entity. Acceptable values are: "OWNER", "READER"
    public var role: String?
    /// The email address associated with the entity, if any.
    public var email: String?
    /// The ID for the entity, if any.
    public var entityId: String?
    /// The domain associated with the entity, if any.
    public var domain: String?
    /// The project team associated with the entity, if any.
    public var projectTeam: ProjectTeam?
    /// HTTP 1.1 Entity tag for the access-control entry.
    public var etag: String?
    
    public init(kind: String? = nil,
                id: String? = nil,
                selfLink: String? = nil,
                bucket: String? = nil,
                object: String? = nil,
                generation: String? = nil,
                entity: String? = nil,
                role: String? = nil,
                email: String? = nil,
                entityId: String? = nil,
                domain: String? = nil,
                projectTeam: ProjectTeam? = nil,
                etag: String? = nil) {
        self.kind = kind
        self.id = id
        self.selfLink = selfLink
        self.bucket = bucket
        self.object = object
        self.generation = generation
        self.entity = entity
        self.role = role
        self.email = email
        self.entityId = entityId
        self.domain = domain
        self.projectTeam = projectTeam
        self.etag = etag
    }
}

public struct ProjectTeam: GoogleCloudModel {
    /// The project number.
    public var projectNumber: String?
    /// The team. Acceptable values are: "editors", "owners", "viewers"
    public var team: String?
    
    public init(projectNumber: String? = nil,
                team: String? = nil) {
        self.projectNumber = projectNumber
        self.team = team
    }
}

public struct Owner: GoogleCloudModel {
    /// The entity, in the form project-owner-projectId.
    public var entity: String?
    /// The ID for the entity.
    public var entityId: String?
    
    public init(entity: String? = nil,
                entityId: String? = nil) {
        self.entity = entity
        self.entityId = entityId
    }
}

public struct Website: GoogleCloudModel {
    /// If the requested object path is missing, the service will ensure the path has a trailing '/', append this suffix, and attempt to retrieve the resulting object. This allows the creation of index.html objects to represent directory pages.
    public var mainPageSuffix: String?
    /// If the requested object path is missing, and any mainPageSuffix object is missing, if applicable, the service will return the named object from this bucket as the content for a 404 Not Found result.
    public var notFoundPage: String?
    
    public init(mainPageSuffix: String? = nil,
                notFoundPage: String? = nil) {
        self.mainPageSuffix = mainPageSuffix
        self.notFoundPage = notFoundPage
    }
}

public struct Logging: GoogleCloudModel {
    /// The destination bucket where the current bucket's logs should be placed.
    public var logBucket: String?
    /// A prefix for log object names.
    public var logObjectPrefix: String?
    
    public init(logBucket: String? = nil,
                logObjectPrefix: String? = nil) {
        self.logBucket = logBucket
        self.logObjectPrefix = logObjectPrefix
    }
}

public struct Versioning: GoogleCloudModel {
    /// While set to true, versioning is fully enabled for this bucket.
    public var enabled: Bool?
    
    public init(enabled: Bool? = nil) {
        self.enabled = enabled
    }
}

public struct Cors: GoogleCloudModel {
    /// The list of Origins eligible to receive CORS response headers. Note: "*" is permitted in the list of origins, and means "any Origin".
    public var origin: [String]?
    /// The list of HTTP methods on which to include CORS response headers, (GET, OPTIONS, POST, etc) Note: "*" is permitted in the list of methods, and means "any method".
    public var method: [String]?
    /// The list of HTTP headers other than the simple response headers to give permission for the user-agent to share across domains.
    public var responseHeader: [String]?
    /// The value, in seconds, to return in the Access-Control-Max-Age header used in preflight responses.
    public var maxAgeSeconds: Int?
    
    public init(origin: [String]? = nil,
                method: [String]? = nil,
                responseHeader: [String]? = nil,
                maxAgeSeconds: Int? = nil) {
        self.origin = origin
        self.method = method
        self.responseHeader = responseHeader
        self.maxAgeSeconds = maxAgeSeconds
    }
}

public struct Lifecycle: GoogleCloudModel {
    /// A lifecycle management rule, which is made of an action to take and the condition(s) under which the action will be taken.
    public var rule: [Rule]?
    
    public init(rule: [Rule]? = nil) {
        self.rule = rule
    }
}

public struct Rule: GoogleCloudModel {
    /// The action to take.
    public var action: Action?
    /// The condition(s) under which the action will be taken.
    public var condition: Condition?
    
    public init(action: Action? = nil,
                condition: Condition? = nil) {
        self.action = action
        self.condition = condition
    }
}

public struct Action: GoogleCloudModel {
    /// Type of the action. Currently, only Delete and SetStorageClass are supported. Acceptable values are: "Delete", "SetStorageClass"
    public var type: String?
    /// Target storage class. Required iff the type of the action is SetStorageClass.
    public var storageClass: String?
    
    public init(type: String? = nil,
                storageClass: String? = nil) {
        self.type = type
        self.storageClass = storageClass
    }
}

public struct Condition: GoogleCloudModel {
    /// Age of an object (in days). This condition is satisfied when an object reaches the specified age.
    public var age: Int?
    /// A date in RFC 3339 format with only the date part (for instance, "2013-01-15"). This condition is satisfied when an object is created before midnight of the specified date in UTC.
    public var createdBefore: String?
    /// Relevant only for versioned objects. If the value is true, this condition matches live objects; if the value is false, it matches archived objects.
    public var isLive: Bool?
    /// Objects having any of the storage classes specified by this condition will be matched. Values include MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, STANDARD, and DURABLE_REDUCED_AVAILABILITY.
    public var matchesStorageClass: [String]?
    /// Relevant only for versioned objects. If the value is N, this condition is satisfied when there are at least N versions (including the live version) newer than this version of the object.
    public var numNewerVersions: Int?
    
    public init(age: Int? = nil,
                createdBefore: String? = nil,
                isLive: Bool? = nil,
                matchesStorageClass: [String]? = nil,
                numNewerVersions: Int? = nil) {
        self.age = age
        self.createdBefore = createdBefore
        self.isLive = isLive
        self.matchesStorageClass = matchesStorageClass
        self.numNewerVersions = numNewerVersions
    }
}

public struct Billing: GoogleCloudModel {
    /// When set to true, bucket is requester pays.
    public var requesterPays: Bool?
    
    public init(requesterPays: Bool? = nil) {
        self.requesterPays = requesterPays
    }
}

public struct Encryption: GoogleCloudModel {
    /// When set to true, bucket is requester pays.
    public var defaultKmsKeyName: String?
    
    public init(defaultKmsKeyName: String? = nil) {
        self.defaultKmsKeyName = defaultKmsKeyName
    }
}

public struct RetentionPolicy: GoogleCloudModel {
    /// The time from which the retentionPolicy was effective, in RFC 3339 format.
    public var effectiveTime: Date?
    /// Whether or not the retentionPolicy is locked. If true, the retentionPolicy cannot be removed and the retention period cannot be reduced.
    public var isLocked: Bool?
    /// The period of time, in seconds, that objects in the bucket must be retained and cannot be deleted, overwritten, or archived. The value must be greater than 0 seconds and less than 3,155,760,000 seconds.
    public var retentionPeriod: Int?
}

public struct EmptyResponse: GoogleCloudModel {}
