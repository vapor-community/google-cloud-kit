//
//  StorageObject.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 5/20/18.
//

import Core
import Foundation

public struct GoogleCloudStorageObject: Codable {
    /// The kind of item this is. For objects, this is always storage#object.
    public var kind: String?
    /// The ID of the object, including the bucket name, object name, and generation number.
    public var id: String?
    /// The link to this object.
    public var selfLink: String?
    /// The name of the object. Required if not specified by URL parameter.
    public var name: String?
    /// The name of the bucket containing this object.
    public var bucket: String?
    /// The content generation of this object. Used for object versioning.
    public var generation: String?
    /// The version of the metadata for this object at this generation. Used for preconditions and for detecting changes in metadata. A metageneration number is only meaningful in the context of a particular generation of a particular object.
    public var metageneration: String?
    /// Content-Type of the object data. If an object is stored without a Content-Type, it is served as application/octet-stream.
    public var contentType: String?
    /// The creation time of the object in RFC 3339 format.
    public var timeCreated: Date?
    /// The modification time of the object metadata in RFC 3339 format.
    public var updated: Date?
    /// The deletion time of the object in RFC 3339 format. Will be returned if and only if this version of the object has been deleted.
    public var timeDeleted: Date?
    /// Storage class of the object.
    public var storageClass: String?
    /// The time at which the object's storage class was last changed. When the object is initially created, it will be set to timeCreated.
    public var timeStorageClassUpdated: Date?
    /// Content-Length of the data in bytes.
    public var size: String?
    /// MD5 hash of the data; encoded using base64.
    public var md5Hash: String?
    /// Media download link.
    public var mediaLink: String?
    /// Content-Encoding of the object data.
    public var contentEncoding: String?
    /// Content-Disposition of the object data.
    public var contentDisposition: String?
    /// Content-Language of the object data.
    public var contentLanguage: String?
    /// Cache-Control directive for the object data. If omitted, and the object is accessible to all anonymous users, the default will be public, max-age=3600.
    public var cacheControl: String?
    /// User-provided metadata, in key/value pairs.
    public var metadata: [String: String]?
    /// Access controls on the object, containing one or more objectAccessControls
    public var acl: [ObjectAccessControls]?
    /// The owner of the object. This will always be the uploader of the object.
    public var owner: Owner?
    /// CRC32c checksum, as described in RFC 4960, Appendix B; encoded using base64 in big-endian byte order.
    public var crc32c: String?
    /// Number of underlying components that make up this object. Components are accumulated by compose operations and are limited to a count of 1024, counting 1 for each non-composite component object and componentCount for each composite component object. Note: componentCount is included in the metadata for composite objects only.
    public var componentCount: Int?
    /// HTTP 1.1 Entity tag for the object.
    public var etag: String?
    /// Metadata of customer-supplied encryption key, if the object is encrypted by such a key.
    public var customerEncryption: CustomerEncryption?
    /// Cloud KMS Key used to encrypt this object, if the object is encrypted by such a key.
    public var kmsKeyName: String?
    
    public init(kind: String? = nil,
                id: String? = nil,
                selfLink: String? = nil,
                name: String? = nil,
                bucket: String? = nil,
                generation: String? = nil,
                metageneration: String? = nil,
                contentType: String? = nil,
                timeCreated: Date? = nil,
                updated: Date? = nil,
                timeDeleted: Date? = nil,
                storageClass: String? = nil,
                timeStorageClassUpdated: Date? = nil,
                size: String? = nil,
                md5Hash: String? = nil,
                mediaLink: String? = nil,
                contentEncoding: String? = nil,
                contentDisposition: String? = nil,
                contentLanguage: String? = nil,
                cacheControl: String? = nil,
                metadata: [String: String]? = nil,
                acl: [ObjectAccessControls]? = nil,
                owner: Owner? = nil,
                crc32c: String? = nil,
                componentCount: Int? = nil,
                etag: String? = nil,
                customerEncryption: CustomerEncryption? = nil,
                kmsKeyName: String? = nil) {
        self.kind = kind
        self.id = id
        self.selfLink = selfLink
        self.name = name
        self.bucket = bucket
        self.generation = generation
        self.metageneration = metageneration
        self.contentType = contentType
        self.timeCreated = timeCreated
        self.updated = updated
        self.timeDeleted = timeDeleted
        self.storageClass = storageClass
        self.timeStorageClassUpdated = timeStorageClassUpdated
        self.size = size
        self.md5Hash = md5Hash
        self.mediaLink = mediaLink
        self.contentEncoding = contentEncoding
        self.contentDisposition = contentDisposition
        self.contentLanguage = contentLanguage
        self.cacheControl = cacheControl
        self.metadata = metadata
        self.acl = acl
        self.owner = owner
        self.crc32c = crc32c
        self.componentCount = componentCount
        self.etag = etag
        self.customerEncryption = customerEncryption
        self.kmsKeyName = kmsKeyName
    }
}

public struct CustomerEncryption: Codable {
    /// The encryption algorithm.
    public var encryptionAlgorithm: String?
    /// SHA256 hash value of the encryption key.
    public var keySha256: String?
    
    public init(encryptionAlgorithm: String? = nil,
                keySha256: String? = nil) {
        self.encryptionAlgorithm = encryptionAlgorithm
        self.keySha256 = keySha256
    }
}

public struct StorageSourcObject: Codable {
    /// The source object's name. The source object's bucket is implicitly the destination bucket.
    public var name: String?
    /// The generation of this object to use as the source.
    public var generation: String?
    /// Conditions that must be met for this operation to execute.
    public var objectPreconditions: StorageObjectPreconditions?
    
    public init(name: String? = nil,
                generation: String? = nil,
                objectPreconditions: StorageObjectPreconditions? = nil) {
        self.name = name
        self.generation = generation
        self.objectPreconditions = objectPreconditions
    }
}

public struct StorageObjectPreconditions: Codable {
    /// Only perform the composition if the generation of the source object that would be used matches this value. If this value and a generation are both specified, they must be the same value or the call will fail.
    public var ifGenerationMatch: String?
    
    public init(ifGenerationMatch: String? = nil) {
        self.ifGenerationMatch = ifGenerationMatch
    }
}

public struct StorageRewriteObject: Codable {
    /// The kind of item this is.
    public var kind: String?
    
    ///The total bytes written so far, which can be used to provide a waiting user with a progress indicator. This property is always present in the response.
    public var totalBytesRewritten: String?
    
    /// The total size of the object being copied in bytes. This property is always present in the response.
    public var objectSize: String?
    
    /// true if the copy is finished; otherwise, false if the copy is in progress. This property is always present in the response.
    public var done: Bool?
    
    /// A token to use in subsequent requests to continue copying data. This token is present in the response only when there is more data to copy.
    public var rewriteToken: String?
    
    /// A resource containing the metadata for the copied-to object. This property is present in the response only when copying completes.
    public var resource: GoogleCloudStorageObject?
    
    public init(kind: String? = nil,
                totalBytesRewritten: String? = nil,
                objectSize: String? = nil,
                done: Bool? = nil,
                rewriteToken: String? = nil,
                resource: GoogleCloudStorageObject? = nil) {
        self.kind = kind
        self.totalBytesRewritten = totalBytesRewritten
        self.objectSize = objectSize
        self.done = done
        self.rewriteToken = rewriteToken
        self.resource = resource
    }
}

public struct StorageNotificationChannel: Codable {
    /// Identifies this as a notification channel used to watch for changes to a resource. Value: the fixed string "api#channel".
    public var kind: String?
    
    /// A UUID or similar unique string that identifies this channel.
    public var id: String?
    
    /// An opaque ID that identifies the resource being watched on this channel. Stable across different API versions.
    public var resourceId: String?
    
    /// A version-specific identifier for the watched resource.
    public var resourceUri: String?
    
    /// An arbitrary string delivered to the target address with each notification delivered over this channel. Optional.
    public var token: String?
    
    /// Date and time of notification channel expiration, expressed as a Unix timestamp, in milliseconds. Optional.
    public var expiration: String?
    
    /// The type of delivery mechanism used for this channel. Value: the fixed string "WEBHOOK".
    public var type: String?
    
    /// The address where notifications are delivered for this channel.
    public var address: String?
    
    /// Additional parameters controlling delivery channel behavior. Optional.
    public var params: [String: String]?
    
    /// A Boolean value to indicate whether payload is wanted. Optional.
    public var payload: Bool?
    
    public init(kind: String? = nil,
                id: String? = nil,
                resourceId: String? = nil,
                resourceUri: String? = nil,
                token: String? = nil,
                expiration: String? = nil,
                type: String? = nil,
                address: String? = nil,
                params: [String: String]? = nil,
                payload: Bool? = nil) {
        self.kind = kind
        self.id = id
        self.resourceId = resourceId
        self.resourceUri = resourceUri
        self.token = token
        self.expiration = expiration
        self.type = type
        self.address = address
        self.params = params
        self.payload = payload
    }
}

public struct GoogleCloudStorgeDataResponse: Codable {
    public var data: Data?
}
