//
//  GoogleCloudAPIConfiguration.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 11/15/18.
//

import Foundation

/// Protocol for each GoogleCloud API configuration.
public protocol GoogleCloudAPIConfiguration {
    var scope: [GoogleCloudAPIScope] { get }
    var serviceAccount: String { get }
    var project: String? { get }
}

public protocol GoogleCloudAPIScope {
    var value: String { get }
}
