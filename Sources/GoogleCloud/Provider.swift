//
//  StorageBucket.swift
//  GoogleCloudProvider
//
//  Created by Andrew Edwards on 4/17/18.
//

import Vapor

public struct GoogleCloudProviderConfig: Service {
    let serviceAccountCredentialPath: String
    let project: String?

    public init(project: String? = nil, credentialFile: String? = nil) {
        self.project = project
        
        let env = ProcessInfo.processInfo.environment
        // Locate the credentials to use for this client. In order of priority:
        // - Environment Variable Specified Credentials (GOOGLE_APPLICATION_CREDENTIALS)
        // - CredentialFile (optionally configured)
        // - Application Default Credentials, located in the constant
        self.serviceAccountCredentialPath = env["GOOGLE_APPLICATION_CREDENTIALS"] ??
            credentialFile ??
        "~/.config/gcloud/application_default_credentials.json"
    }
}


public final class GoogleCloudProvider: Provider {
    
    public static let repositoryName = "google-cloud-provider"
    
    public init() {}
    
    public func boot(_ worker: Container) throws {}
    
    
    public func didBoot(_ worker: Container) throws -> Future<Void> {
        return .done(on: worker)
    }
    
    public func register(_ services: inout Services) throws {
        services.register(GoogleCloudStorageClient.self)
    }
}
