//
//  GoogleCloudStorageConfiguration.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 4/21/18.
//

import Core
import Foundation

public struct GoogleCloudDatastoreConfiguration: GoogleCloudAPIConfiguration {
    public var scope: [GoogleCloudAPIScope]
    public let serviceAccount: String
    public let project: String?
    public let subscription: String? = nil
    
    public init(scope: [GoogleCloudDatastoreScope], serviceAccount: String, project: String?) {
        self.scope = scope
        self.serviceAccount = serviceAccount
        self.project = project
    }
    
    /// Create a new `GoogleCloudDatastoreConfiguration` with datastore scope and the default service account.
    public static func `default`() -> GoogleCloudDatastoreConfiguration {
        return GoogleCloudDatastoreConfiguration(scope: [.datastore],
                                               serviceAccount: "default",
                                               project: nil)
    }
}

public enum GoogleCloudDatastoreScope: GoogleCloudAPIScope {
    /// View and manage your Google Cloud Datastore data
    case datastore
    /// View and manage your data across Google Cloud Platform services
    case cloudPlatform
    
    public var value: String {
        switch self {
            case .datastore: return "https://www.googleapis.com/auth/datastore"
            case .cloudPlatform: return "https://www.googleapis.com/auth/cloud-platform"
        }
    }
}
