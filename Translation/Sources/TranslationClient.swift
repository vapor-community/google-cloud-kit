import Core
import Foundation
import AsyncHTTPClient
import NIO

public struct GoogleCloudTranslationClient {
    public var translation: TranslationBasicAPI
    let translationRequest: GoogleCloudTranslationRequest

    public init(strategy: CredentialsLoadingStrategy, client: HTTPClient, base: String = "https://translation.googleapis.com") async throws {
        let resolvedCredentials = try await CredentialsResolver.resolveCredentials(strategy: strategy)
        
        switch resolvedCredentials {
        case .gcloud(let gCloudCredentials):
            let provider = GCloudCredentialsProvider(client: client, credentials: gCloudCredentials)
            translationRequest = .init(tokenProvider: provider, client: client, project: gCloudCredentials.quotaProjectId)
            
        case .serviceAccount(let serviceAccountCredentials):
            let provider = ServiceAccountCredentialsProvider(client: client, credentials: serviceAccountCredentials)
            translationRequest = .init(tokenProvider: provider, client: client, project: serviceAccountCredentials.projectId)
            
        case .computeEngine(let metadataUrl):
            let projectId = ProcessInfo.processInfo.environment["PROJECT_ID"] ?? "default"
            switch strategy {
            case .computeEngine(let client, let scope):
                let provider = ComputeEngineCredentialsProvider(client: client, scopes: scope, url: metadataUrl)
                translationRequest = .init(tokenProvider: provider, client: client, project: projectId)
            default:
                let provider = ComputeEngineCredentialsProvider(client: client, scopes: [], url: metadataUrl)
                translationRequest = .init(tokenProvider: provider, client: client, project: projectId)
            }
        }
        
        translation = GoogleCloudTranslationBasicAPI(request: translationRequest, endpoint: base)
    }
}
