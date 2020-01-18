//
//  GoogleCloudError.swift
//  GoogleCloud
//
//  Created by Andrew Edwards on 11/16/18.
//

import NIOHTTP1

public protocol GoogleCloudError: Error {}

enum CredentialLoadError: GoogleCloudError {
    case fileLoadError(String)
    case jsonLoadError
    
    var localizedDescription: String {
        switch self {
        case .fileLoadError(let path):
            return "Failed to load GoogleCloud credentials from the file path \(path)"
        case .jsonLoadError:
            return "Failed to load GoogleCloud credentials from the JSON provided in the environment variable"
        }
    }
}

enum OauthRefreshError: GoogleCloudError {
    case noResponse(HTTPResponseStatus)
    
    var localizedDescription: String {
        switch self {
        case .noResponse(let status):
            return "A request to the OAuth authorization server failed with response status \(status.code)."
        }
    }
}



public struct GoogleCloudAPIErrorMain: GoogleCloudError, GoogleCloudModel {
    /// A container for the error information.
    public var error: GoogleCloudAPIErrorBody
    
    public init (error : GoogleCloudAPIErrorBody ) {
        self.error = error
    }
}

public struct GoogleCloudAPIErrorBody: Codable {
    /// A container for the error details.
    public var errors: [GoogleCloudAPIError]
    /// An HTTP status code value, without the textual description.
    public var code: Int
    /// Description of the error. Same as `errors.message`.
    public var message: String
    
    public init (errors: [GoogleCloudAPIError], code: Int, message: String) {
        self.errors = errors
        self.code = code
        self.message = message
    }
}

public struct GoogleCloudAPIError: Codable {
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
