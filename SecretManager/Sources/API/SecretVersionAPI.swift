import AsyncHTTPClient
import NIO
import Foundation

public protocol SecretVersionAPI {
    func access(secret: String, version: String) async throws -> SecretVersionData
    
    func destroy(secret: String, version: String, etag: String?) async throws -> SecretVersion
    
    func enable(secret: String, version: String, etag: String?) async throws -> SecretVersion
    
    func disable(secret: String, version: String, etag: String?) async throws -> SecretVersion
    
    func get(secret: String, version: String) async throws -> SecretVersion
}

public extension SecretVersionAPI {
    /// Accesses a `SecretVersion`. This call returns the secret data.
    /// - Parameters:
    ///   - secret: The resource name of the `SecretVersion`
    ///   - version: The version of the secret to access. Defaults to "latest"
    /// - Returns: `SecretVersionData`
    func access(secret: String, version: String = "latest") async throws -> SecretVersionData {
        try await access(secret: secret, version: version)
    }
    
    /// Destroys a `SecretVersion`.
    ///
    /// Sets the `state` of the `SecretVersion` to `DESTROYED` and irrevocably destroys the secret data.
    /// - Parameters:
    ///   - secret: The resource name of the `SecretVersion` to destroy
    ///   - version: The version of the secret to destroy. Defaults to "latest"
    ///   - etag: Etag of the `SecretVersion`. The request succeeds if it matches the etag of the currently stored secret version object. If the etag is omitted, the request succeeds.
    /// - Returns: `SecretVersion`
    func destroy(secret: String, version: String = "latest", etag: String? = nil) async throws -> SecretVersion {
        try await destroy(secret: secret, version: version, etag: etag)
    }
    
    /// Disables a `SecretVersion`.
    ///
    /// Sets the `state` of the `SecretVersion` to `DISABLED` and irrevocably destroys the secret data.
    /// - Parameters:
    ///   - secret: The resource name of the `SecretVersion` to enable
    ///   - version: The version of the secret to enable. Defaults to "latest"
    ///   - etag: Etag of the `SecretVersion`. The request succeeds if it matches the etag of the currently stored secret version object. If the etag is omitted, the request succeeds.
    /// - Returns: `SecretVersion`
    func enable(secret: String, version: String = "latest", etag: String? = nil) async throws -> SecretVersion {
        try await destroy(secret: secret, version: version, etag: etag)
    }
    
    /// Enables a `SecretVersion`.
    ///
    /// Sets the `state` of the `SecretVersion` to `ENABLED` and irrevocably destroys the secret data.
    /// - Parameters:
    ///   - secret: The resource name of the `SecretVersion` to disable
    ///   - version: The version of the secret to disable. Defaults to "latest"
    ///   - etag: Etag of the `SecretVersion`. The request succeeds if it matches the etag of the currently stored secret version object. If the etag is omitted, the request succeeds.
    /// - Returns: `SecretVersion`
    func disable(secret: String, version: String = "latest", etag: String? = nil) async throws -> SecretVersion {
        try await destroy(secret: secret, version: version, etag: etag)
    }
    
    
    /// Gets metadata for a `SecretVersion`.
    /// - Parameters:
    ///   - secret: The resource name of the SecretVersion in the format.
    ///   - version: The version of the secret to get. Defaults to "latest"
    /// - Returns: `SecretVersion`
    func get(secret: String, version: String = "latest") async throws -> SecretVersion {
        try await get(secret: secret, version: version)
    }
}

public final class GoogleCloudSecretManagerSecretVersionAPI: SecretVersionAPI {
    let endpoint: String
    let request: GoogleCloudSecretManagerRequest
    
    init(request: GoogleCloudSecretManagerRequest, endpoint: String) {
        self.request = request
        self.endpoint = endpoint
    }
    
    private var secretsPath: String {
        "\(endpoint)/v1/projects/\(request.project)/secrets"
    }
    
    public func access(_ secret: String, version: String = "latest") async throws -> SecretVersionData {
        try await request.send(method: .GET, path: "\(secretsPath)/\(secret)/versions/\(version):access")
    }
    
    public func destroy(secret: String, version: String = "latest", etag: String?) async throws -> SecretVersion {
        var body: Data = Data()
        if let etag = etag {
            body = try JSONSerialization.data(withJSONObject: ["etag": etag], options: [])
        }
        
        return try await request.send(method: .POST, path: "\(secretsPath)/\(secret)/versions/\(version):destroy", body: .bytes(.init(data: body)))
    }
    
    public func enable(secret: String, version: String = "latest", etag: String?) async throws -> SecretVersion {
        var body: Data = Data()
        if let etag = etag {
            body = try JSONSerialization.data(withJSONObject: ["etag": etag], options: [])
        }
        
        return try await request.send(method: .POST, path: "\(secretsPath)/\(secret)/versions/\(version):enable", body: .bytes(.init(data: body)))
    }
    
    public func disable(secret: String, version: String = "latest", etag: String?) async throws -> SecretVersion {
        var body: Data = Data()
        if let etag = etag {
            body = try JSONSerialization.data(withJSONObject: ["etag": etag], options: [])
        }
        
        return try await request.send(method: .POST, path: "\(secretsPath)/\(secret)/versions/\(version):disable", body: .bytes(.init(data: body)))
    }
    
    public func get(secret: String, version: String = "latest") async throws -> SecretVersion {
        try await request.send(method: .GET, path: "\(secretsPath)/\(secret)/versions/\(version)")
    }
}
