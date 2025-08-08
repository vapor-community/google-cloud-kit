import Core

public struct GoogleCloudIdentityToolkitConfiguration: GoogleCloudAPIConfiguration {
    public var scope: [GoogleCloudAPIScope]
    public let serviceAccount: String
    public let project: String?
    public let subscription: String? = nil
    
    public init(scope: [GoogleCloudIdentityToolkitScope], serviceAccount: String, project: String?) {
        self.scope = scope
        self.serviceAccount = serviceAccount
        self.project = project
    }
    
    /// Create a new `IdentityToolkitConfiguration` with default scope and service account
    public static func `default`() -> GoogleCloudIdentityToolkitConfiguration {
        return GoogleCloudIdentityToolkitConfiguration(
            scope: [.identityToolkit],
            serviceAccount: "default",
            project: nil
        )
    }
}

public enum GoogleCloudIdentityToolkitScope: GoogleCloudAPIScope {
    case identityToolkit
    case firebase
    case cloudPlatform
    
    public var value: String {
        return switch self {
            case .identityToolkit: "https://www.googleapis.com/auth/identitytoolkit"
            case .firebase: "https://www.googleapis.com/auth/firebase"
            case .cloudPlatform: "https://www.googleapis.com/auth/cloud-platform"
        }
    }
} 
