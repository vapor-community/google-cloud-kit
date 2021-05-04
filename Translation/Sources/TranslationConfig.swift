import Core

public struct GoogleCloudTranslationConfiguration: GoogleCloudAPIConfiguration {
    public var scope: [GoogleCloudAPIScope]
    public let serviceAccount: String
    public let project: String?
    public let subscription: String? = nil

    public init(scope: [GoogleCloudTranslationScope], serviceAccount: String, project: String?) {
        self.scope = scope
        self.serviceAccount = serviceAccount
        self.project = project
    }

    /// Create a new `GoogleCloudTranslationConfiguration` with cloud platform scope and the default service account.
    public static func `default`() -> GoogleCloudTranslationConfiguration {
        return GoogleCloudTranslationConfiguration(scope: [.cloudPlatform],
                                                   serviceAccount: "default",
                                                   project: nil)
    }
}

public enum GoogleCloudTranslationScope: GoogleCloudAPIScope {
    /// View and manage your data across Google Cloud Platform services

    case cloudPlatform

    public var value: String {
        switch self {
        case .cloudPlatform: return "https://www.googleapis.com/auth/cloud-platform"
        }
    }
}
