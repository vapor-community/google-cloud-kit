//
//  GoogleCloudAPIClient.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 8/5/19.
//

import Foundation
import AsyncHTTPClient

public protocol GoogleCloudAPIClient {
    var tokenProvider: AccessTokenProvider { get }
}
