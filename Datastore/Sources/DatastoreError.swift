//
//  CloudStorageError.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 4/21/18.
//

import Core
import Foundation

public enum GoogleCloudDatastoreError: GoogleCloudError {
    case projectIdMissing
    case unknownError(String)
    
    var localizedDescription: String {
        switch self {
        case .projectIdMissing:
            return "Missing project id for GoogleCloudDatastore API. Did you forget to set your project id?"
        case .unknownError(let reason):
            return "An unknown error occured: \(reason)"
        }
    }
}

/// [Reference](https://cloud.google.com/storage/docs/json_api/v1/status-codes)
public struct CloudDatastoreAPIError: GoogleCloudError, GoogleCloudModel {
    /// A container for the error information.
    public var error: CloudDatastoreAPIErrorBody
}

public struct CloudDatastoreAPIErrorBody: Codable {
    /// A container for the error details.
    public var errors: [CloudDatastoreError]
    /// An HTTP status code value, without the textual description.
    public var code: Int
    /// Description of the error. Same as `errors.message`.
    public var message: String
}

public struct CloudDatastoreError: Codable {
    /// The scope of the error. Example values include: global, push and usageLimits.
    public var domain: String?
    /// Example values include invalid, invalidParameter, and required.
    public var reason: String?
    /// Description of the error.
    /// Example values include Invalid argument, Login required, and Required parameter: project.
    public var message: String?
    /// The location or part of the request that caused the error. Use with location to pinpoint the error. For example, if you specify an invalid value for a parameter, the locationType will be parameter and the location will be the name of the parameter.
    public var locationType: String?
    /// The specific item within the locationType that caused the error. For example, if you specify an invalid value for a parameter, the location will be the name of the parameter.
    public var location: String?
}
