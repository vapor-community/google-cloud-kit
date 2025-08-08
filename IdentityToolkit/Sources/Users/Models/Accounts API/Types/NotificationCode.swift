import Core
import Foundation

public enum NotificationCode: String, GoogleCloudModel {
    case unspecified = "NOTIFICATION_CODE_UNSPECIFIED"
    case missingLowercaseCharacter = "MISSING_LOWERCASE_CHARACTER"
    case missingUppercaseCharacter = "MISSING_UPPERCASE_CHARACTER"
    case missingNumericCharacter = "MISSING_NUMERIC_CHARACTER"
    case missingNonAlphanumericCharacter = "MISSING_NON_ALPHANUMERIC_CHARACTER"
    case minimumPasswordLength = "MINIMUM_PASSWORD_LENGTH"
    case maximumPasswordLength = "MAXIMUM_PASSWORD_LENGTH"
} 