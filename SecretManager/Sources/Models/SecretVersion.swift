//
//  SecretVersion.swift
//  
//
//  Created by Andrew Edwards on 2/20/22.
//

import Foundation

/// A secret version resource in the Secret Manager API.
public struct SecretVersion: Codable {
    /// The resource name of the SecretVersion in the format `projects/*/secrets/*/versions/*`.
    public var name: String
    /// The time at which the SecretVersion was created.
    public var createTime: Date
    /// The time this SecretVersion was destroyed. Only present if `state` is `destroyed`.
    public var destroyTime: Date?
    /// The current state of the SecretVersion.
    public var state: SecretVersionState
    /// The replication status of the SecretVersion.
    public var replicationStatus: SecretVersionReplicationStatus
    /// Etag of the currently stored SecretVersion.
    public var etag: String
}

/// The state of a SecretVersion, indicating if it can be accessed.
public enum SecretVersionState: String, Codable {
    /// Not specified. This value is unused and invalid.
    case unspecified = "STATE_UNSPECIFIED"
    /// The SecretVersion may be accessed
    case enabled = "ENABLED"
    /// The SecretVersion may not be accessed, but the secret data is still available and can be placed back into the `enabled` state.
    case disabled = "DISABLED"
    /// The SecretVersion is destroyed and the secret data is no longer stored. A version may not leave this state once entered.
    case destroyed = "DESTROYED"
}

/// The replication status of a SecretVersion.
public struct SecretVersionReplicationStatus: Codable {
    /// Describes the replication status of a SecretVersion with automatic replication.
    ///
    /// Only populated if the parent Secret has an automatic replication policy.
    public var automatic: SecretVersionReplicationStatusAutomatic?
    /// Describes the replication status of a SecretVersion with user-managed replication.
    ///
    /// Only populated if the parent Secret has a user-managed replication policy.
    public var userManaged: SecretVersionReplicationStatusUserManaged?
}

/// The replication status of a SecretVersion using automatic replication.
///
/// Only populated if the parent Secret has an automatic replication policy.
public struct SecretVersionReplicationStatusAutomatic: Codable {
    public var customerManagedEncryption: SecretVersionReplicationStatusAutomaticCustomerManagedEncryption?
}

/// Describes the status of customer-managed encryption.
public struct SecretVersionReplicationStatusAutomaticCustomerManagedEncryption: Codable {
    /// The resource name of the Cloud KMS CryptoKeyVersion used to encrypt the secret payload, in the following format: `projects/*/locations/*/keyRings/*/cryptoKeys/*/versions/*`.
    public var kmsKeyVersionName: String
}

/// Describes the status of customer-managed encryption.
public struct SecretVersionReplicationStatusUserManaged: Codable {
    /// The list of replica statuses for the SecretVersion.
    public var replicas: [ReplicaStatus]
}

/// Describes the status of a user-managed replica for the SecretVersion.
public struct ReplicaStatus: Codable {
    /// The canonical ID of the replica location. For example: "us-east1".
    public var location: String
    /// The customer-managed encryption status of the SecretVersion. Only populated if customer-managed encryption is used.
    public var customerManagedEncryption: SecretVersionReplicationStatusAutomaticCustomerManagedEncryption?
}
