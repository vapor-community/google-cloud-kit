//
//  StorageScope.swift
//  GoogleCloudProvider
//
//  Created by Andrew Edwards on 4/16/18.
//

import Vapor

public struct StorageScope {
    /// Only allows access to read data, including listing buckets.
    public static let readOnly = "https://www.googleapis.com/auth/devstorage.read_only"
    /// Allows access to read and change data, but not metadata like IAM policies.
    public static let readWrite = "https://www.googleapis.com/auth/devstorage.read_write"
    /// Allows full control over data, including the ability to modify IAM policies.
    public static let fullControl = "https://www.googleapis.com/auth/devstorage.full_control"
    /// View your data across Google Cloud Platform services. For Cloud Storage, this is the same as devstorage.read-only.
    public static let cloudPlatformReadOnly = "https://www.googleapis.com/auth/cloud-platform.read-only"
    /// View and manage data across all Google Cloud Platform services. For Cloud Storage, this is the same as devstorage.full-control.
    public static let cloudPlatform = "https://www.googleapis.com/auth/cloud-platform"
}
