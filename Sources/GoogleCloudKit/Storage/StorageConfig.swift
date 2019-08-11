//
//  GoogleCloudStorageConfiguration.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 4/21/18.
//

import Foundation

public struct GoogleCloudStorageConfiguration: GoogleCloudAPIConfiguration {
    public var scope: [GoogleCloudAPIScope]
    public let serviceAccount: String
    public let project: String?
    
    public init(scope: [GoogleCloudStorageScope], serviceAccount: String, project: String?) {
        self.scope = scope
        self.serviceAccount = serviceAccount
        self.project = project
    }
    
    /// Create a new `GoogleCloudStorageConfig` with full control scope and the default service account.
    public static func `default`() -> GoogleCloudStorageConfiguration {
        return GoogleCloudStorageConfiguration(scope: [.fullControl],
                                               serviceAccount: "default",
                                               project: nil)
    }
}

public enum GoogleCloudStorageScope: GoogleCloudAPIScope {
    /// Only allows access to read data, including listing buckets.
    case readOnly
    /// Allows access to read and change data, but not metadata like IAM policies.
    case readWrite
    /// Allows full control over data, including the ability to modify IAM policies.
    case fullControl
    /// View your data across Google Cloud Platform services. For Cloud Storage, this is the same as devstorage.read-only.
    case cloudPlatformReadOnly
    /// View and manage data across all Google Cloud Platform services. For Cloud Storage, this is the same as devstorage.full-control.
    case cloudPlatform
    
    public var value: String {
        switch self {
            case .readOnly: return "https://www.googleapis.com/auth/devstorage.read_only"
            case .readWrite: return "https://www.googleapis.com/auth/devstorage.read_write"
            case .fullControl: return "https://www.googleapis.com/auth/devstorage.full_control"
            case .cloudPlatformReadOnly: return "https://www.googleapis.com/auth/cloud-platform.read-only"
            case .cloudPlatform: return "https://www.googleapis.com/auth/cloud-platform"
        }
    }
}
