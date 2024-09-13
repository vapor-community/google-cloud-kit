//
//  VisionError.swift
//
//
//  Created by Kostis Stefanou on 12/9/24.
//

import Core
import Foundation

public enum GoogleCloudVisionError: GoogleCloudError {
    case projectIdMissing
    case unknownError(String)
    
    var localizedDescription: String {
        switch self {
        case .projectIdMissing:
            return "Missing project id for GoogleCloudStorage API. Did you forget to set your project id?"
        case .unknownError(let reason):
            return "An unknown error occured: \(reason)"
        }
    }
}

/// [Reference](https://cloud.google.com/vision/docs/reference/rest/v1/Status)
public struct VisionAPIError: GoogleCloudError, GoogleCloudModel {
    /// An HTTP status code value, without the textual description.
    public var code: Int
    /// Description of the error. Same as `errors.message`.
    public var message: String
    ///A list of messages that carry the error details. There is a common set of message types for APIs to use.
    public var details: [String: String]
}

public struct VisionError: Codable {
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
