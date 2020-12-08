import Core
import Foundation

public enum GoogleCloudSecretManagerError: GoogleCloudError {
    case projectIdMissing
    case unknownError(String)
    
    var localizedDescription: String {
        switch self {
        case .projectIdMissing:
            return "Missing project id for GoogleCloudSecretManager API. Did you forget to set your project id?"
        case .unknownError(let reason):
            return "An unknown error occured: \(reason)"
        }
    }
}

public struct SecretManagerAPIError: GoogleCloudError, GoogleCloudModel {
    /// A container for the error information.
    public var error: SecretManagerAPIErrorBody
}

public struct SecretManagerAPIErrorBody: Codable {
    /// A container for the error details.
    public var status: Status
    /// An HTTP status code value, without the textual description.
    public var code: Int
    /// Description of the error. Same as `errors.message`.
    public var message: String
    
    public enum Status: String, RawRepresentable, Codable {
        case unknownError
        case alreadyExists = "ALREADY_EXISTS"
        case deadlineExceeded = "DEADLINE_EXCEEDED"
        case failedPrecondition = "FAILED_PRECONDITION"
        case internalError = "INTERNAL"
        case notFound = "NOT_FOUND"
        case permissionDenied = "PERMISSION_DENIED"
        case resourceExhausted = "RESOURCE_EXHAUSTED"
        case unauthenticated = "UNAUTHENTICATED"
        case unavailable = "UNAVAILABLE"
    }
}

public struct SecretManagerError: Codable {
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
