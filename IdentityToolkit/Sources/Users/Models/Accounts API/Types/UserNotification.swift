import Core
import Foundation

public struct UserNotification: GoogleCloudModel {
    /// Warning notification enum
    public let notificationCode: NotificationCode
    /// Warning notification string
    public let notificationMessage: String
} 