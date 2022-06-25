//
//  StorageScope.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 4/21/18.
//

import Core
import Foundation

public enum GoogleCloudStorageScope: GoogleCloudAPIScope, CaseIterable {
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
