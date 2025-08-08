import Core
import Foundation

public enum OobReqType: String, GoogleCloudModel {
    case passwordReset = "PASSWORD_RESET"
    case emailSignin = "EMAIL_SIGNIN"
    case verifyEmail = "VERIFY_EMAIL"
    case verifyAndChangeEmail = "VERIFY_AND_CHANGE_EMAIL"
} 