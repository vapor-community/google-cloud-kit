import Core

public struct SignJWTResponse: GoogleCloudModel {
    
    public let keyId: String
    public let signedJwt: String
}
