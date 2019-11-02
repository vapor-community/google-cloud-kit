//
//  GoogleCloudCredentialsConfiguration.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 4/17/18.
//

import Foundation

public struct GoogleCloudCredentialsConfiguration {
    public let serviceAccountCredentialsPath: String
    public let project: String?
    
    public init(projectId: String? = nil, credentialsFile: String? = nil) {
        project = projectId
        let env = ProcessInfo.processInfo.environment
        
        // Locate the credentials to use for this client. In order of priority:
        // - Environment Variable Specified Credentials (GOOGLE_APPLICATION_CREDENTIALS)
        // https://cloud.google.com/docs/authentication/production#obtaining_and_providing_service_account_credentials_manually
        // - CredentialFile (optionally configured)
        // - Application Default Credentials.
        // https://cloud.google.com/docs/authentication/production#providing_credentials_to_your_application
        self.serviceAccountCredentialsPath = env["GOOGLE_APPLICATION_CREDENTIALS"] ??
                                             credentialsFile ??
                                             "~/.config/gcloud/application_default_credentials.json"
    }
}
