import Core

public struct IAMServiceAccountCredentialsConfiguration: GoogleCloudAPIConfiguration {
    public var scope: [GoogleCloudAPIScope]
    public let serviceAccount: String
    public let project: String?
    public let subscription: String? = nil
    
    public init(scope: [GoogleCloudIAMServiceAccountCredentialsScope], serviceAccount: String, project: String?) {
        self.scope = scope
        self.serviceAccount = serviceAccount
        self.project = project
    }
    
    /// Create a new `IAMServiceAccountCredentialsConfiguration` with cloud platform scope and the default service account.
    public static func `default`() -> IAMServiceAccountCredentialsConfiguration {
        return IAMServiceAccountCredentialsConfiguration(scope: [.cloudPlatform],
                                                 serviceAccount: "default",
                                                 project: nil)
    }
}

public enum GoogleCloudIAMServiceAccountCredentialsScope: GoogleCloudAPIScope {
    /// View and manage your data across Google Cloud Platform services
    
    case cloudPlatform
    case iam
    
    public var value: String {
        return switch self {
            case .cloudPlatform: "https://www.googleapis.com/auth/cloud-platform"
            case .iam: "https://www.googleapis.com/auth/iam"
        }
    }
}
