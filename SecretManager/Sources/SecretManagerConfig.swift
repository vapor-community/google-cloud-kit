import Core

public struct GoogleCloudSecretManagerConfiguration: GoogleCloudAPIConfiguration {
    public var scope: [GoogleCloudAPIScope]
    public let serviceAccount: String
    public let project: String?
    public let subscription: String? = nil
    
    public init(scope: [GoogleCloudSecretManagerScope], serviceAccount: String, project: String?) {
        self.scope = scope
        self.serviceAccount = serviceAccount
        self.project = project
    }
    
    /// Create a new `GoogleCloudSecretManagerConfiguration` with cloud platform scope and the default service account.
    public static func `default`() -> GoogleCloudSecretManagerConfiguration {
        return GoogleCloudSecretManagerConfiguration(scope: [.cloudPlatform],
                                                 serviceAccount: "default",
                                                 project: nil)
    }
}

public enum GoogleCloudSecretManagerScope: GoogleCloudAPIScope {
    /// View and manage your data across Google Cloud Platform services
    
    case cloudPlatform
    
    public var value: String {
        switch self {
        case .cloudPlatform: return "https://www.googleapis.com/auth/cloud-platform"
        }
    }
}
