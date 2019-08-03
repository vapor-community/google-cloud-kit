//
//  OAuthComputeEngine+AppEngineFlex.swift
//  GoogleCloud
//
//  Created by Andrew Edwards on 11/15/18.
//

import Vapor

// TODO: - Implement instance metadata API and have as separate module or class maybe? Probably a separate class/file.
// Implementation is really straight forward https://cloud.google.com/compute/docs/storing-retrieving-metadata#default
public class OAuthComputeEngineAppEngineFlex: OAuthRefreshable {
    let serviceAccount: String
    let client: Client
    var serviceAccountTokenURL: String {
      return "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/\(serviceAccount)/token"
    }
    
    init(serviceAccount: String = "default", httpClient: Client) {
        self.serviceAccount = serviceAccount
        self.client = httpClient
    }
    
    public func refresh() throws -> Future<OAuthAccessToken> {
        let headers: HTTPHeaders = ["Metadata-Flavor": "Google"]
        return client.get(serviceAccountTokenURL, headers: headers, beforeSend: { _ in }).flatMap(to: OAuthAccessToken.self) { response in
            if response.http.status == .ok {
                return try JSONDecoder().decode(OAuthAccessToken.self, from: response.http, maxSize: 65_536, on: response)
            }
            throw Abort(response.http.status, reason: "An unexpected error occured when querying the metadata server.")
        }
    }
}
