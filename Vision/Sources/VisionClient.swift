//
//  VisionClient.swift
//
//
//  Created by Kostis Stefanou on 12/9/24.
//

import Core
import Foundation
import AsyncHTTPClient
import NIO

public final class GoogleCloudVisionClient {
    
    public var vision: VisionAPI
    var translationRequest: GoogleCloudVisionRequest
    
    /// Initialize a client for interacting with the Google Cloud Translation API
    /// - Parameter credentials: The Credentials to use when authenticating with the APIs
    /// - Parameter config: The configuration for the Translation API
    /// - Parameter httpClient: An `HTTPClient` used for making API requests.
    /// - Parameter eventLoop: The EventLoop used to perform the work on.
    /// - Parameter base: The base URL to use for the Translation API
    public init(credentials: GoogleCloudCredentialsConfiguration,
                config: GoogleCloudVisionConfiguration,
                httpClient: HTTPClient,
                eventLoop: EventLoop,
                base: String = "https://vision.googleapis.com") throws {
        /// A token implementing `OAuthRefreshable`. Loaded from credentials specified by `GoogleCloudCredentialsConfiguration`.
        let refreshableToken = OAuthCredentialLoader.getRefreshableToken(credentials: credentials,
                                                                         withConfig: config,
                                                                         andClient: httpClient,
                                                                         eventLoop: eventLoop)
        
        /// Set the projectId to use for this client. In order of priority:
        /// - Environment Variable (GOOGLE_PROJECT_ID)
        /// - Environment Variable (PROJECT_ID)
        /// - Service Account's projectID
        /// - `GoogleCloudTranslationConfigurations` `project` property (optionally configured).
        /// - `GoogleCloudCredentialsConfiguration's` `project` property (optionally configured).
        
        guard let projectId = ProcessInfo.processInfo.environment["GOOGLE_PROJECT_ID"] ??
                ProcessInfo.processInfo.environment["PROJECT_ID"] ??
                (refreshableToken as? OAuthServiceAccount)?.credentials.projectId ??
                config.project ?? credentials.project else {
            throw GoogleCloudVisionError.projectIdMissing
        }
        
        translationRequest = GoogleCloudVisionRequest(httpClient: httpClient,
                                                      eventLoop: eventLoop,
                                                      oauth: refreshableToken,
                                                      project: projectId)
        
        vision = GoogleCloudVisionAPI(request: translationRequest, endpoint: base)
    }
    
    /// Hop to a new eventloop to execute requests on.
    /// - Parameter eventLoop: The eventloop to execute requests on.
    public func hopped(to eventLoop: EventLoop) -> GoogleCloudVisionClient {
        translationRequest.eventLoop = eventLoop
        return self
    }
}
