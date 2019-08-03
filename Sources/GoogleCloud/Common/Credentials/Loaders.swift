//
//  Loaders.swift
//  Async
//
//  Created by Brian Hatfield on 7/17/18.
//

import Foundation

enum CredentialLoadError: GoogleCloudError {
    
    var localizedDescription: String {
        switch self {
        case .fileLoadError(let path):
            return "Failed to load GoogleCloud credentials from the file path \(path)"
        case .jsonLoadError:
            return "Failed to load GoogleCloud credentials from the JSON provided in the environment variable"
        }
    }
    var identifier: String {
        switch self {
        case .fileLoadError(_):
            return "file-load-error"
        case .jsonLoadError:
            return "json-load-error"
        }
    }
    
    var reason: String { return localizedDescription }
    
    case fileLoadError(String)
    case jsonLoadError
}

extension GoogleApplicationDefaultCredentials {
    init(contentsOfFile path: String) throws {
        let decoder = JSONDecoder()
        let filePath = NSString(string: path).expandingTildeInPath
        
        if let contents = try String(contentsOfFile: filePath).data(using: .utf8) {
            self = try decoder.decode(GoogleApplicationDefaultCredentials.self, from: contents)
        } else {
            throw CredentialLoadError.fileLoadError(path)
        }
    }
}

// Decodes JSON in String form
extension GoogleApplicationDefaultCredentials {
    init(json: String) throws {
        let decoder = JSONDecoder()
        
        if let data = json.data(using: .utf8) {
            self = try decoder.decode(GoogleApplicationDefaultCredentials.self, from: data)
        } else {
            throw CredentialLoadError.jsonLoadError
        }
    }
}

extension GoogleServiceAccountCredentials {
    init(contentsOfFile path: String) throws {
        let decoder = JSONDecoder()
        let filePath = NSString(string: path).expandingTildeInPath
        
        if let contents = try String(contentsOfFile: filePath).data(using: .utf8) {
            self = try decoder.decode(GoogleServiceAccountCredentials.self, from: contents)
        } else {
            throw CredentialLoadError.fileLoadError(path)
        }
    }
}

// Decodes JSON in String form
extension GoogleServiceAccountCredentials {
    init(json: String) throws {
        let decoder = JSONDecoder()
        
        if let data = json.data(using: .utf8) {
            self = try decoder.decode(GoogleServiceAccountCredentials.self, from: data)
        } else {
            throw CredentialLoadError.jsonLoadError
        }
    }
}
