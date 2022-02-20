//
//  CredentialsResolver.swift
//  
//
//  Created by Andrew Edwards on 2/19/22.
//

import Foundation
import AsyncHTTPClient

public struct CredentialsResolver {
    public static func resolveCredentials(strategy: CredentialsLoadingStrategy) async throws -> ResolvedCredentials {
        let env = ProcessInfo.processInfo.environment
        switch strategy {
        case .filePath(let path, let credentialsType):
            guard let contents = try String(contentsOfFile: path).data(using: .utf8) else {
                throw CredentialLoadError.fileLoadError(path)
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            switch credentialsType {
            case .gcloud:
                return try .gcloud(decoder.decode(GCloudCredentials.self, from: contents))
            case .serviceAccount:
                return try .serviceAccount(decoder.decode(ServiceAccountCredentials.self, from: contents))
            }
            
        case .environment:
            // try to load from the env var first then the default location
            let path = env["GOOGLE_APPLICATION_CREDENTIALS"] ?? "\(NSHomeDirectory())/.config/gcloud/application_default_credentials.json"
            
            guard let contents = try String(contentsOfFile: path).data(using: .utf8) else {
                throw CredentialLoadError.fileLoadError(path)
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                return try .gcloud(decoder.decode(GCloudCredentials.self, from: contents))
            } catch DecodingError.keyNotFound(_, _) {
                do {
                    return try .serviceAccount(decoder.decode(ServiceAccountCredentials.self, from: contents))
                } catch {
                    throw CredentialLoadError.fileLoadError(path)
                }
            }
            
        case .computeEngine(let client, _):
            // check if we're allowed to check for GCE environment
            guard (env["NO_GCE_CHECK"] ?? "false").lowercased() == "false" else {
                throw CredentialLoadError.computeEngineCheckNotAvailable
            }
            
            // Now check if we actually are running on compute engine.
            
            // construct the metadata server url
            let metadataServerUrl: String
            if let host = env["GCE_METADATA_HOST"] {
                metadataServerUrl = "http://\(host)"
            } else {
                metadataServerUrl = ComputeEngineCredentialsProvider.metadataServerUrl
            }
            
            // See if we can ping the metadata server.
            // we'll try 5 times before bailing
            var request = HTTPClientRequest(url: metadataServerUrl)
            request.headers.add(name: "Metadata-Flavor", value: "Google")
            
            for attempt in 1...5 {
                do {
                    let response = try await client.execute(request, timeout: .milliseconds(500))
                    
                    // Internet providers can return a generic response to all requests, so it is necessary
                    // to check that metadata header is present also.
                    if response.headers.first(name: "Metadata-Flavor") == .some("Google") {
                        return .computeEngine(metadataServerUrl)
                    } else {
                        throw CredentialLoadError.computeEngineNotAvailable
                    }
                } catch {
                    if attempt == 5 {
                        throw CredentialLoadError.computeEngineNotAvailable
                    } else {
                        continue
                    }
                }
            }
            throw CredentialLoadError.computeEngineNotAvailable
        }
    }
}
