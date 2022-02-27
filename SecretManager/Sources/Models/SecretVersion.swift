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


//{"type": "service_account", "project_id": "helixbooking-201615", "private_key_id": "09b21dd34488fd40ebfb53a57357ab35a1eafe46", "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCW/Tzv6rFdWSSA\nRIEdVzRhn60bmBwXX0UGAqH/swOHk3xixMhlo9y38ytp2IWYEpYe3gQeHas5nLbU\nOsXYCUgJNIii6GjTH3511V1Ig6OTBFaqXFnHhKTQXR5ftISB415NZefXmLIpmlPM\nCuzClf1feX3BB8Q2FgdyaYf10ONiKvCGwihDKy/ImBFoYUDHaYFU5iQJ9TbkLu+F\ni6d31vLkPk/wBqrWAjPhK2pCMOIBeepDowILnScbGh0Kk1pfVquS0RmbL24p5oj7\nGTUWi4MI4CN16a8NmfUeby/bIfJVPvSWFA6eJh9A4LZ+3HksFh3PYTtzUoup7HQ2\nl3cBjW8rAgMBAAECggEAPoxHiyfRM9dyzIQUbKAsfeiU4KKBuJjp0hSTIYb6Blbt\np0jXr2tTSwy8RkvBA/9nGwBj+knWHbay8nYqcVVe9xlBJSNcEWGxlIS/8QM/Zu7c\nLBS3yHRFhl+c7o6sedZDwZJemayS2bMp1ZQNAor5/Gwq0SUzfihgC2B2RzmyiH6Y\nXJ7mnG4m5oBlqkDvPNbOIbGCTUT9f1ISsYRHmXa3SGS5NpNXgsAjKOAXu45LvnO8\nH98wdbT5G6yldQ9Vt1UGmEQF/KS12Fhim+4KKXRtWGyZ/d1ZSsYTvOEY0MBF0RkM\nicffiVh7M0meDtKsXHOHknQ8bU910omTg/HVrY2rwQKBgQDIKrebPvK45QWdbz38\nyTBjKU7sMy+y9kAhRVDo497W5j3Qt5wwthCGTdCCD+XAen9w7T5R/7KjUb9xHEms\nRWIpHXXKJ5DOE5we0L5d3OG8CaIYU14ze3NXL8RP/YgQT+z7dAf0R/jQpVgLF3Lj\nBSBDbtnjZ3SPuh/fZi9Ve+TeiwKBgQDBGuZvEysgyFPeQ+OElj6FbWvJQKSBS7Gg\nloTBS817MNrZUN7kZM0aIJPYf+9tQewNCNoebbk/aFPX7ARsRKUHjWLyIa48Y5dS\nWmazvNI7Rd6RAoKDiaHwl1o1XSSYFycNxCeHt1QQ/QH8S4XOn7vVXFpuv09+mb4F\nkQTLmOtl4QKBgFeERc680QcCK1hQQPv7Qwq4Due64YoPnK5vThblOpMfC7vr64Bo\nugTelOGo7b0gUgQf1nWnpIU/wsJDqfqGQ4rSdKO0dN2FOWdHwVPstU2vsI2ONcuw\nmBdwrRaENS9corK2Ypvts94VzM7cq8CShy60ktOYciA9Mp5MYTmw97pNAoGBAKat\niWkmqntJbtrSzneLF7wjjn3QBi50H4X1ZfFSdLJ4oO4jF8EcIM0EgZjGFOvBkvZN\nRbguDU/lxTkCx26MccXrDBTjbXlCnULANRW/TddLn6ia+fx/t//rJDobg5KjqVoA\njf5fB3kCacxTg9OtnHu1k3k0OHGWUqaLXhA+ljEBAoGAKN2IAVVTr2mr9sGTiQE7\n9CGBOfH5JYN5bqV+u1OrEEP7nz/mg9FlOgVlFEStDqljppg9ZEkD4zEs2QCZ+p2n\nKHx0UdDw+y1Kd4nQwYbLuw5meGdydO6uW9CppjX7ZWX1Hb7wkCBPx+puMBG9MqBy\nQV9F39Efx6gsNEQCg24LdEs=\n-----END PRIVATE KEY-----\n", "client_email": "helix-business-cloud-storage@helixbooking-201615.iam.gserviceaccount.com", "client_id": "114054666517285587011", "auth_uri": "https://accounts.google.com/o/oauth2/auth", "token_uri": "https://oauth2.googleapis.com/token", "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs", "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/helix-business-cloud-storage%40helixbooking-201615.iam.gserviceaccount.com"}
