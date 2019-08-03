//
//  StorageConfig.swift
//  GoogleCloudProvider
//
//  Created by Andrew Edwards on 4/21/18.
//

import Vapor

public struct GoogleCloudStorageConfig: Service, GoogleCloudAPIConfig {
    
    public let scope: [String]
    public let serviceAccount: String
    public let project: String?
    
    public init(scope: [String], serviceAccount: String, project: String?) {
        self.scope = scope
        self.serviceAccount = serviceAccount
        self.project = project
    }
    
    /// Create a new `GoogleCloudStorageConfig` with full control scope and the default service account.
    public static func `default`() -> GoogleCloudStorageConfig {
        return GoogleCloudStorageConfig(scope: [StorageScope.fullControl], serviceAccount: "default", project: nil)
    }
}

