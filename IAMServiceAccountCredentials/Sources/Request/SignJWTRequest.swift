import Core
import Foundation
import JWTKit

public struct SignJWTRequest: GoogleCloudModel {
    
    public init(jwt: JWTPayload, delegates: [String] = []) throws {
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .integerSecondsSince1970

        guard let data = try? encoder.encode(jwt) else {
            throw IAMServiceAccountCredentialsError.jwtEncodingFailed
        }
        
        guard let payload = String(data: data, encoding: .utf8) else {
            throw IAMServiceAccountCredentialsError.jwtConversionFailed
        }
        
        self.payload = payload
        self.delegates = delegates
    }
    
    public let payload: String
    public let delegates: [String]
}

