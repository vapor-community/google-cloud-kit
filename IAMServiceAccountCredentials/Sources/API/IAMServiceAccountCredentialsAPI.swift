import AsyncHTTPClient
import NIO
import Foundation
import JWTKit

public protocol IAMServiceAccountCredentialsAPI {
    func signJWT(_ jwt: JWTPayload, delegates: [String], serviceAccount: String) throws -> EventLoopFuture<SignJWTResponse>
}

public extension IAMServiceAccountCredentialsAPI {
    func signJWT(_ jwt: JWTPayload, delegates: [String] = [], serviceAccount: String) throws -> EventLoopFuture<SignJWTResponse> {
        try signJWT(jwt, delegates: delegates, serviceAccount: serviceAccount)
    }
}

public final class GoogleCloudServiceAccountCredentialsAPI: IAMServiceAccountCredentialsAPI {
    
    let endpoint: String
    let request: IAMServiceAccountCredentialsRequest
    private let encoder = JSONEncoder()
    
    init(request: IAMServiceAccountCredentialsRequest,
         endpoint: String) {
        self.request = request
        self.endpoint = endpoint
    }
    
    public func signJWT(_ jwt: JWTPayload, delegates: [String] = [], serviceAccount: String) throws -> EventLoopFuture<SignJWTResponse> {
        
        do {
            let signJWTRequest = try SignJWTRequest(jwt: jwt, delegates: delegates)
            let body = try HTTPClient.Body.data(encoder.encode(signJWTRequest))
            
            return request.send(method: .POST, path: "\(endpoint)/v1/projects/-/serviceAccounts/\(serviceAccount):signJwt", body: body)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
}
