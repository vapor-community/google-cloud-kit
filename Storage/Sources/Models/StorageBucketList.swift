//
//  StorageBucketList.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 4/18/18.
//

import Core
import Foundation

public struct GoogleCloudStorageBucketList: Codable {
    /// The kind of item this is. For lists of buckets, this is always storage#buckets.
    public var kind: String?
    /// The continuation token, used to page through large result sets. Provide this value in a subsequent request to return the next page of results.
    public var nextPageToken: String?
    /// The list of items.
    public var items: [GoogleCloudStorageBucket]?
}

public struct BucketAccessControlList: Codable {
    /// The kind of item this is. For lists of bucket access control entries, this is always storage#bucketAccessControls.
    public var kind: String?
    /// The list of items.
    public var items: [BucketAccessControls]?
}

public struct ObjectAccessControlsList: Codable {
    /// The kind of item this is. For lists of object access control entries, this is always storage#objectAccessControls
    public var kind: String?
    /// The list of items.
    public var items: [ObjectAccessControls]?
}

public struct StorageNotificationsList: Codable {
    /// The kind of item this is. For lists of notifications, this is always storage#notifications.
    public var kind: String?
    /// The list of items.
    public var items: [StorageNotification]?
}

public struct StorageObjectList: Codable {
    /// The kind of item this is. For lists of objects, this is always storage#objects.
    public var kind: String?
    /// The continuation token, used to page through large result sets. Provide this value in a subsequent request to return the next page of results.
    public var nextPageToken: String?
    
    /// The list of prefixes of objects matching-but-not-listed up to and including the requested delimiter.
    public var prefixes: [String]?
    
    /// The list of items.
    public var items: [GoogleCloudStorageObject]?
}
