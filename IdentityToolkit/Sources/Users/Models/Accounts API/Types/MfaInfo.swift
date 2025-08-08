import Core
import Foundation

public struct MfaInfo: GoogleCloudModel {
    /// The second factors the user has enrolled
    public let enrollments: [MfaEnrollment]?
    
    public init(enrollments: [MfaEnrollment]? = nil) {
        self.enrollments = enrollments
    }
} 