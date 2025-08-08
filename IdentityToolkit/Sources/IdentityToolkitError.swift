import Core
import Foundation

public enum GoogleCloudIdentityToolkitError: GoogleCloudError {
    case projectIdMissing
    case apiKeyMissing
    case unknownError(String)
    
    var localizedDescription: String {
        switch self {
        case .projectIdMissing:
            return "Missing project id for GoogleCloudIdentityToolkit API. Did you forget to set your project id?"
        case .apiKeyMissing:
            return "Missing API key for GoogleCloudIdentityToolkit API. Did you forget to set your API key?"
        case .unknownError(let reason):
            return "An unknown error occured: \(reason)"
        }
    }
}

/// [Reference](https://cloud.google.com/identity-platform/docs/error-codes)
public struct IdentityToolkitAPIError: GoogleCloudError, GoogleCloudModel {
    /// A container for the error information
    public var error: IdentityToolkitAPIErrorBody
}

public struct IdentityToolkitAPIErrorBody: Codable {
    /// A container for the error details
    public var status: Status
    /// An HTTP status code value, without the textual description
    public var code: Int
    /// Description of the error
    public var message: String
    
    public enum Status: String, RawRepresentable, Codable {
        // Account Management Errors
        case requiresRecentLogin = "ERROR_REQUIRES_RECENT_LOGIN"
        
        // Authorization Errors
        case appNotAuthorized = "ERROR_APP_NOT_AUTHORIZED"
        
        // Multi-factor Authentication Errors
        case missingMultiFactorSession = "ERROR_MISSING_MULTI_FACTOR_SESSION"
        case missingMultiFactorInfo = "ERROR_MISSING_MULTI_FACTOR_INFO"
        case invalidMultiFactorSession = "ERROR_INVALID_MULTI_FACTOR_SESSION"
        case multiFactorInfoNotFound = "ERROR_MULTI_FACTOR_INFO_NOT_FOUND"
        case secondFactorRequired = "ERROR_SECOND_FACTOR_REQUIRED"
        case secondFactorAlreadyEnrolled = "ERROR_SECOND_FACTOR_ALREADY_ENROLLED"
        case maximumSecondFactorCountExceeded = "ERROR_MAXIMUM_SECOND_FACTOR_COUNT_EXCEEDED"
        case unsupportedFirstFactor = "ERROR_UNSUPPORTED_FIRST_FACTOR"
        case emailChangeNeedsVerification = "ERROR_EMAIL_CHANGE_NEEDS_VERIFICATION"
        
        // Phone Authentication Errors
        case missingPhoneNumber = "ERROR_MISSING_PHONE_NUMBER"
        case invalidPhoneNumber = "ERROR_INVALID_PHONE_NUMBER"
        case missingVerificationCode = "ERROR_MISSING_VERIFICATION_CODE"
        case invalidVerificationCode = "ERROR_INVALID_VERIFICATION_CODE"
        case missingVerificationId = "ERROR_MISSING_VERIFICATION_ID"
        case invalidVerificationId = "ERROR_INVALID_VERIFICATION_ID"
        case sessionExpired = "ERROR_SESSION_EXPIRED"
        case quotaExceeded = "ERROR_QUOTA_EXCEEDED"
        case appNotVerified = "ERROR_APP_NOT_VERIFIED"
        
        // General Errors
        case captchaCheckFailed = "ERROR_CAPTCHA_CHECK_FAILED"
        case unknownError = "UNKNOWN_ERROR"
        
        // Standard Google Cloud API Errors
        case invalidArgument = "INVALID_ARGUMENT"
        case billingNotEnabled = "BILLING_NOT_ENABLED"
        case failedPrecondition = "FAILED_PRECONDITION"
        case outOfRange = "OUT_OF_RANGE"
        case unauthenticated = "UNAUTHENTICATED"
        case permissionDenied = "PERMISSION_DENIED"
        case notFound = "NOT_FOUND"
        case aborted = "ABORTED"
        case alreadyExists = "ALREADY_EXISTS"
        case resourceExhausted = "RESOURCE_EXHAUSTED"
        case cancelled = "CANCELLED"
        case dataLoss = "DATA_LOSS"
        case unknown = "UNKNOWN"
        case `internal` = "INTERNAL"
        case unavailable = "UNAVAILABLE"
        case deadlineExceeded = "DEADLINE_EXCEEDED"
    }
}

public struct IdentityToolkitError: Codable {
    /// The scope of the error. Example values include: global, push and usageLimits
    public var domain: String?
    /// Example values include invalid, invalidParameter, and required
    public var reason: String?
    /// Description of the error
    /// Example values include Invalid argument, Login required, and Required parameter: project
    public var message: String?
    /// The location or part of the request that caused the error
    public var locationType: String?
    /// The specific item within the locationType that caused the error
    public var location: String?
} 
