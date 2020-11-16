import AsyncHTTPClient
import NIO
import Foundation

public protocol SecretsAPI {
    func access(_ secret: String, version: String) -> EventLoopFuture<AccessSecretVersionResponse>
}

public extension SecretsAPI {
    func access(_ secret: String, version: String = "latest") -> EventLoopFuture<AccessSecretVersionResponse> {
        access(secret, version: version)
    }
}

public final class GoogleCloudSecretManagerSecretsAPI: SecretsAPI {
    
    let endpoint: String
    let request: GoogleCloudSecretManagerRequest
    
    init(request: GoogleCloudSecretManagerRequest,
         endpoint: String) {
        self.request = request
        self.endpoint = endpoint
    }
    
    private var secretsPath: String {
        "\(endpoint)/v1/projects/\(request.project)/secrets"
    }
    
    public func access(_ secret: String, version: String = "latest") -> EventLoopFuture<AccessSecretVersionResponse> {
        request.send(method: .GET, path: "\(secretsPath)/\(secret)/versions/\(version):access")
    }
}
