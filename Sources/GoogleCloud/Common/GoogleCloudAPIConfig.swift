//
//  GoogleCloudAPIConfig.swift
//  GoogleCloud
//
//  Created by Andrew Edwards on 11/15/18.
//

import Foundation

public protocol GoogleCloudAPIConfig {
    var scope: [String] { get }
    var serviceAccount: String { get }
    var project: String? { get }
}
