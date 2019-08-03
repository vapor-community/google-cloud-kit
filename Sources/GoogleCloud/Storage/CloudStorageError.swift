//
//  CloudStorageError.swift
//  GoogleCloudProvider
//
//  Created by Andrew Edwards on 4/21/18.
//

import Vapor

// https://cloud.google.com/storage/docs/json_api/v1/status-codes
public struct CloudStorageError: GoogleCloudError, GoogleCloudModel {
    public var identifier: String {
        return "\(self.error.code)-\(self.error.message)"
    }
    
    public var reason: String {
        return self.error.message
    }
    
    public var error: CloudStorageErrorBody
}

public struct CloudStorageErrorBody: Content {
    public var errors: [CloudStorageErrors]
    public var code: Int
    public var message: String
}

public struct CloudStorageErrors: Content {
    public var domain: String?
    public var reason: String?
    public var message: String?
    public var locationType: String?
    public var location: String?
}
