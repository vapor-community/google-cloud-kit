import Core
import Foundation
import AsyncHTTPClient
import NIO

public struct GoogleCloudSecretManagerClient {
    public var secrets: SecretVersionAPI
    
    let secretManagerRequest: GoogleCloudSecretManagerRequest
    
    public init(strategy: CredentialsLoadingStrategy,
                client: HTTPClient,
                base: String = "https://secretmanager.googleapis.com",
                scope: [GoogleCloudSecretManagerScope]) async throws {
        let resolvedCredentials = try await CredentialsResolver.resolveCredentials(strategy: strategy)
        
        switch resolvedCredentials {
        case .gcloud(let gCloudCredentials):
            let provider = GCloudCredentialsProvider(client: client, credentials: gCloudCredentials)
            secretManagerRequest = .init(tokenProvider: provider, client: client, project: gCloudCredentials.quotaProjectId)
            
        case .serviceAccount(let serviceAccountCredentials):
            let provider = ServiceAccountCredentialsProvider(client: client, credentials: serviceAccountCredentials, scope: scope)
            secretManagerRequest = .init(tokenProvider: provider, client: client, project: serviceAccountCredentials.projectId)
            
        case .computeEngine(let metadataUrl):
            let projectId = ProcessInfo.processInfo.environment["PROJECT_ID"] ?? "default"
            switch strategy {
            case .computeEngine(let client):
                let provider = ComputeEngineCredentialsProvider(client: client, scopes: scope, url: metadataUrl)
                secretManagerRequest = .init(tokenProvider: provider, client: client, project: projectId)
            default:
                let provider = ComputeEngineCredentialsProvider(client: client, scopes: scope, url: metadataUrl)
                secretManagerRequest = .init(tokenProvider: provider, client: client, project: projectId)
            }
        }
        
        secrets = GoogleCloudSecretManagerSecretVersionAPI(request: secretManagerRequest, endpoint: base)
    }
}
