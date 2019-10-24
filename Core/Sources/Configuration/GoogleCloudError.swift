//
//  GoogleCloudError.swift
//  GoogleCloud
//
//  Created by Andrew Edwards on 11/16/18.
//

import NIOHTTP1

public protocol GoogleCloudError: Error {}

enum CredentialLoadError: GoogleCloudError {
    case fileLoadError(String)
    case jsonLoadError
    
    var localizedDescription: String {
        switch self {
        case .fileLoadError(let path):
            return "Failed to load GoogleCloud credentials from the file path \(path)"
        case .jsonLoadError:
            return "Failed to load GoogleCloud credentials from the JSON provided in the environment variable"
        }
    }
}

enum OauthRefreshError: GoogleCloudError {
    case noResponse(HTTPResponseStatus)
    
    var localizedDescription: String {
        switch self {
        case .noResponse(let status):
            return "A request to the OAuth authorization server failed with response status \(status.code)."
        }
    }
}
