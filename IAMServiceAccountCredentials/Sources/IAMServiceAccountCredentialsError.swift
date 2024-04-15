import Core
import Foundation

public enum IAMServiceAccountCredentialsError: GoogleCloudError {
    case projectIdMissing
    case jwtEncodingFailed
    case jwtConversionFailed
    case unknownError(String)
    
    var localizedDescription: String {
        return switch self {
            case .projectIdMissing:
                "Missing project id for GoogleCloudIAMServiceAccountCredentials API. Did you forget to set your project id?"
            case .unknownError(let reason):
                "An unknown error occurred: \(reason)"
            case .jwtEncodingFailed:
                "Failed to encode JWT as JSON"
            case .jwtConversionFailed:
                "Failed to convert encoded JWT to String"
        }
    }
}

public struct IAMServiceAccountCredentialsAPIError: GoogleCloudError, GoogleCloudModel {
    /// A container for the error information.
    public var error: IAMServiceAccountCredentialsAPIErrorBody
}

public struct IAMServiceAccountCredentialsAPIErrorBody: Codable {
    /// A container for the error details.
    public var status: String
    /// An HTTP status code value, without the textual description.
    public var code: Int
    /// Description of the error. Same as `errors.message`.
    public var message: String
}
