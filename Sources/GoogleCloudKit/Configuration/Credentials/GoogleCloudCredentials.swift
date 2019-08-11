//
//  File.swift
//  
//
//  Created by Andrew Edwards on 8/4/19.
//

import Foundation
import AsyncHTTPClient

/// Loads credentials from `~/.config/gcloud/application_default_credentials.json`
struct GoogleApplicationDefaultCredentials: Codable {
    let clientId: String
    let clientSecret: String
    let refreshToken: String
    let type: String
    
    init(fromFilePath path: String) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let contents = try String(contentsOfFile: path).data(using: .utf8) {
            self = try decoder.decode(GoogleApplicationDefaultCredentials.self, from: contents)
        } else {
            throw CredentialLoadError.fileLoadError(path)
        }
    }

    init(fromJsonString json: String) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let data = json.data(using: .utf8) {
            self = try decoder.decode(GoogleApplicationDefaultCredentials.self, from: data)
        } else {
            throw CredentialLoadError.jsonLoadError
        }
    }
}

/// Loads credentials from a file specified in the `GOOGLE_APPLICATION_CREDENTIALS` environment variable
struct GoogleServiceAccountCredentials: Codable {
    let type: String
    let projectId: String
    let privateKeyId: String
    let privateKey: String
    let clientEmail: String
    let clientId: String
    let authUri: URL
    let tokenUri: URL
    let authProviderX509CertUrl: URL
    let clientX509CertUrl: URL
    
    init(fromFilePath path: String) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let contents = try String(contentsOfFile: path).data(using: .utf8) {
            self = try decoder.decode(GoogleServiceAccountCredentials.self, from: contents)
        } else {
            throw CredentialLoadError.fileLoadError(path)
        }
    }
    
    init(fromJsonString json: String) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let data = json.data(using: .utf8) {
            self = try decoder.decode(GoogleServiceAccountCredentials.self, from: data)
        } else {
            throw CredentialLoadError.jsonLoadError
        }
    }
}

public class OAuthCredentialLoader {
    public static func getRefreshableToken(credentialFilePath: String, withConfig config: GoogleCloudAPIConfiguration, andClient client: HTTPClient) throws -> OAuthRefreshable {
        
        // Check Service account first.
        if let credentials = try? GoogleServiceAccountCredentials(fromFilePath: credentialFilePath) {
            return OAuthServiceAccount(credentials: credentials, scopes: config.scope, httpClient: client)
        }

        if let credentials = try? GoogleServiceAccountCredentials(fromJsonString: credentialFilePath) {
            return OAuthServiceAccount(credentials: credentials, scopes: config.scope, httpClient: client)
        }
        
        
        // Check Default application credentials next.
        if let credentials = try? GoogleApplicationDefaultCredentials(fromFilePath: credentialFilePath) {
            return OAuthApplicationDefault(credentials: credentials, httpClient: client)
        }

        if let credentials = try? GoogleApplicationDefaultCredentials(fromJsonString: credentialFilePath) {
            return OAuthApplicationDefault(credentials: credentials, httpClient: client)
        }

        // If neither work assume we're on GCP infrastructure.
        return OAuthComputeEngineAppEngineFlex(serviceAccount: config.serviceAccount, httpClient: client)
    }
}
