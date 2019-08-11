//
//  StorageClass.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 4/17/18.
//

import Foundation

public enum GoogleCloudStorageClass: String {
    /// Storing data that is frequently accessed ("hot" objects) around the world, such as serving website content, streaming videos, or gaming and mobile applications.
    case multiRegional = "multi_regional"
    /// Storing frequently accessed in the same region as your Google Cloud DataProc or Google Compute Engine instances that use it, such as for data analytics.
    case regional
    /// Data you do not expect to access frequently (i.e., no more than once per month). Ideal for back-up and serving long-tail multimedia content.
    case nearline
    /// Data you expect to access infrequently (i.e., no more than once per year). Typically this is for disaster recovery, or data that is archived and may or may not be needed at some future time.
    case coldline
}
