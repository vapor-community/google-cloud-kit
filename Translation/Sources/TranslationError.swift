import Core
import Foundation

public enum GoogleCloudTranslationError: GoogleCloudError {
    case unknownError(String)

    var localizedDescription: String {
        switch self {
        case .unknownError(let reason):
            return "An unknown error occured: \(reason)"
        }
    }
}

public struct TranslationAPIError: GoogleCloudError, Codable {
    /// A container for the error information.
    public var error: TranslationAPIErrorBody
}

public struct TranslationAPIErrorBody: Codable {
    /// A container for the error details.
    public var status: String
    /// An HTTP status code value, without the textual description.
    public var code: Int
    /// Description of the error. Same as `errors.message`.
    public var message: String
}

public struct TranslationError: Codable {
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
