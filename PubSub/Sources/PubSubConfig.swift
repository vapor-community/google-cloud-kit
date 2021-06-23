import Core

public struct GoogleCloudPubSubConfiguration: GoogleCloudAPIConfiguration {
    public var scope: [GoogleCloudAPIScope]
    public let serviceAccount: String
    public let project: String?
    public let subscription: String? = nil
    
    public init(scope: [GoogleCloudPubSubScope], serviceAccount: String, project: String?) {
        self.scope = scope
        self.serviceAccount = serviceAccount
        self.project = project
    }
    
    /// Create a new `GoogleCloudTranslationConfiguration` with cloud platform scope and the default service account.
    public static func `default`() -> GoogleCloudPubSubConfiguration {
        return GoogleCloudPubSubConfiguration(scope: [.cloudPlatform],
                                                   serviceAccount: "default",
                                                   project: nil)
    }
}

public enum GoogleCloudPubSubScope: GoogleCloudAPIScope {
    /// View and manage Pub/Sub topics and subscriptions
    case pubsub
    
    /// See, edit, configure, and delete your Google Cloud Platform data
    case cloudPlatform

    public var value: String {
        switch self {
        case .pubsub: return "https://www.googleapis.com/auth/pubsub"
        case .cloudPlatform: return "https://www.googleapis.com/auth/cloud-platform"
        }
    }
}
