//
//  CredentialLoadingStrategy.swift
//  
//
//  Created by Andrew Edwards on 2/19/22.
//

import Foundation
import NIO
import AsyncHTTPClient

public enum CredentialsLoadingStrategy {
    /// Load the credentials from the specified file path and parse them into the corrosponding `CredentialsType`.
    case filePath(String, CredentialsType)
    /// Load the credentials form the environment and let the SDK figure out what the `CredentialsType` is.
    case environment
    /// Use the metadata API and provide a list of scopes for the credentials.
    ///
    /// You should use this if the client runs on a Google virtual machine instance such as Compute Engine.
    case computeEngine(client: HTTPClient)
    /// Loads the credentials as JSON from environment variables as opposed to a file path on disk.
    case environmentJSON
}
