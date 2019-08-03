//
//  OAuthCredentialLoader.swift
//  GoogleCloudProvider
//
//  Created by Brian Hatfield on 7/19/18.
//

import Vapor

public class OAuthCredentialLoader {
    public static func getRefreshableToken(credentialFilePath: String, withConfig config: GoogleCloudAPIConfig, andClient client: Client) throws -> OAuthRefreshable {
        
        // Tries to access file first
        if let credentials = try? GoogleServiceAccountCredentials(contentsOfFile: credentialFilePath) {
            return OAuthServiceAccount(credentials: credentials, scopes: config.scope, httpClient: client)
        }
        
        // Then tries to decode as JSON
        if let credentials = try? GoogleServiceAccountCredentials(json: credentialFilePath) {
            return OAuthServiceAccount(credentials: credentials, scopes: config.scope, httpClient: client)
        }
        
        if let credentials = try? GoogleApplicationDefaultCredentials(contentsOfFile: credentialFilePath) {
            return OAuthApplicationDefault(credentials: credentials, httpClient: client)
        }
        
        if let credentials = try? GoogleApplicationDefaultCredentials(json: credentialFilePath) {
            return OAuthApplicationDefault(credentials: credentials, httpClient: client)
        }
        
        return OAuthComputeEngineAppEngineFlex(serviceAccount: config.serviceAccount, httpClient: client)
    }
}
