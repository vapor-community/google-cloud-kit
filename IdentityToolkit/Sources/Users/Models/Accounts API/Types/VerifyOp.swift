import Core
import Foundation

public enum VerifyOp: String, GoogleCloudModel {
    case unspecified = "VERIFY_OP_UNSPECIFIED"
    case signUpOrIn = "SIGN_UP_OR_IN"
    case reauth = "REAUTH"
    case update = "UPDATE"
    case link = "LINK"
} 