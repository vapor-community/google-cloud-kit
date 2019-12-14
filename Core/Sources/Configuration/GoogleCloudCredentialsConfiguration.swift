//
//  GoogleCloudCredentialsConfiguration.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 4/17/18.
//

import Foundation

public struct GoogleCloudCredentialsConfiguration {
    public let project: String?
    public var serviceAccountCredentials: GoogleServiceAccountCredentials?
    public var applicationDefaultCredentials: GoogleApplicationDefaultCredentials?
    
    public init(projectId: String? = nil, credentialsFile: String? = nil) throws {
        project = projectId
        let env = ProcessInfo.processInfo.environment
        
        // Locate the credentials to use for this client. In order of priority:
        // - Environment Variable Specified Credentials (GOOGLE_APPLICATION_CREDENTIALS)
        // https://cloud.google.com/docs/authentication/production#obtaining_and_providing_service_account_credentials_manually
        // - CredentialFile (optionally configured)
        // - Application Default Credentials.
        // https://cloud.google.com/docs/authentication/production#providing_credentials_to_your_application
        let serviceAccountCredentialsPath = env["GOOGLE_APPLICATION_CREDENTIALS"] ??
                                             credentialsFile ??
                                             "~/.config/gcloud/application_default_credentials.json"
                
        if let serviceaccount = try? GoogleServiceAccountCredentials(fromFilePath: serviceAccountCredentialsPath) {
            self.serviceAccountCredentials = serviceaccount
        } else {
            self.serviceAccountCredentials = try? GoogleServiceAccountCredentials(fromJsonString: serviceAccountCredentialsPath)
        }
        
        if let defaultcredentials = try? GoogleApplicationDefaultCredentials(fromFilePath: serviceAccountCredentialsPath) {
            self.applicationDefaultCredentials = defaultcredentials
        } else {
            self.applicationDefaultCredentials = try? GoogleApplicationDefaultCredentials(fromJsonString: serviceAccountCredentialsPath)
        }
    }
}
