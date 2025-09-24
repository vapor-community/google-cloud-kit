//
//  CredentialTests.swift
//  Async
//
//  Created by Brian Hatfield on 7/17/18.
//

import Foundation
import XCTest
import JWTKit

@testable import Core

final class CredentialTests: XCTestCase {

    func testJWTGenerationDoesNotCrash() async throws {
        // This test verifies that our JWT generation code with the new JWT Kit 5.x doesn't crash
        // We use a valid RSA private key generated with OpenSSL

        let validPrivateKey = """
-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEA2bP4t6JbghdRKsF7xd/4GvfTKc91AwK+xRk5wWWvHqZO70W3
4erjue0uBHePrh83wu1IGb4Xa6gFbV0g14h45Pyn/a3BLk+cJqpfUoIqmAhnOi83
bKMiQsIRFMQ2u2B/M8KCG/fE7X2b82oPObWI6Je/Ytwb3PtyLzCtvdBRMoi1JfoZ
/rd2hJlL24XXkCy4k0Y7xRHcZ1i1p5on5Z+ELJvzALPV1uwlJSH7iP5US1XDy4f7
nXzNj6UhDskCn0egDtfQV6xP1VG2iIBOVzsZMigT7rSPXdXH8UeES1HSwkE8asQa
6QmFm7NJEf68CnE1fuW8MzHII9v3BXfT1sMNYQIDAQABAoIBAFTjs6FPguU4WGMW
rT/cdK93YXTVO2hgIqlSi83Y669E5FSy1+AVKpVuYdpGENWxwJmW0t2O3S0SiIM7
pDnHMnT//DWUElcPnfEJ0D+pGBjOdgofLTqEZjCn4ec6F6l7GD7Dot5q//QnXa9N
9P/oxKkFuxA+ifLibYTvM2BnobHVGoUtQlULKyDip9VINETfxnAkL99OSZ0MZ9iC
qnpTqF5nPZLzzGhPW1+LBUW0T/cetIcQdtVbifed3dXJ05frzbbYcWjSCTS0+i/L
rKryipf4rOhXGo447Y+yM3+uivtX/WYJK8STun1AxX0Y9EFuXjSUse3XwkpVwST4
ZObhskECgYEA+SYIGouBr172hk1bifd3hdtcf+aRCiAK9gu4yQK8kLsQx2WnF3AV
SHUhhbZyJRVxQtYXn5qR7UE9ehhIgGtatcgp/nBSOUSniHz5MY6MSZedXz5BFreE
acX38mq+tcIX+Rl+dxdjO9s2R0I05n4fHIH8G54UDhDCYpEJZS1RZYkCgYEA37CR
ZyjIw7sAI323SRFZdCd+L0bvaBaocu9aGl2rxuomSIEpGZnXYEoy67jyXgnbxZya
Uv9RQ08JpHZCi7378fke/w96XVeSlFZM9KCKSpWwy0I/SmUmAPgX2ZWfW7Ekf0XJ
QNPUE/KQUEfqRxV3LSn2eYnZdJyPpIQLHnVJSxkCgYEA4xKIfDj9fyoboRfMABhs
9LCSw3cOZZ4Cn3Dbf0hhN79mcXTyLuhWXW1zmfxIWAgM7A9YBHzJ1uSI9UhAe9pc
GCVQMLeKGOu7jSfprgLvVPs70NxaUiv8ILLvYh9rpRg65SsZGc1VAe6ur49ly1TT
YhYOAdW3DYK0x0TMvUvqTZECgYEAnGi48vn4j6v1J9viyeugsfBfci1Wf2DAfkVQ
qnjvANJ+3Fm75FPG3mRjgKG8jvazvlSHMBuotbjRVDcAxveb8JEyFES9WgE+1AwY
GUEcEZTjnux+lsVtMmZHPvQ5DoMpsviYBYVYmG4WbJwse3HN+D2MQ2WZMMm8Qtu1
bqGyExkCgYEA9a9feZcQuANz+1ZnKl2a30osorE1XBwJR+dJlxqtbNs3vXqSJNC4
M3hbohiVBJfVLPrFq3i8m3lewZyNXQw/1b8w+EriHlDBCAAXfdT2Wqt0KK669c2z
s3Baj1fc55dq4cc8EiwvDNGD39xZBMJJDQ1YwGfvByN6bGjmFm9Cdwg=
-----END RSA PRIVATE KEY-----
"""

        // Test that creating an OAuthPayload and JWT generation doesn't crash
        let payload = OAuthPayload(
            iss: IssuerClaim(value: "test@test-project.iam.gserviceaccount.com"),
            scope: "https://www.googleapis.com/auth/cloud-platform",
            aud: AudienceClaim(value: "https://oauth2.googleapis.com/token"),
            exp: ExpirationClaim(value: Date().addingTimeInterval(3600)),
            iat: IssuedAtClaim(value: Date()),
            sub: nil
        )

        // This should not crash with the new JWT Kit 5.x API
        XCTAssertNoThrow(try Insecure.RSA.PrivateKey(pem: validPrivateKey.data(using: String.Encoding.utf8) ?? Data()))

        let privateKey = try Insecure.RSA.PrivateKey(pem: validPrivateKey.data(using: String.Encoding.utf8) ?? Data())
        let keyCollection = JWTKeyCollection()
        await keyCollection.add(rsa: privateKey, digestAlgorithm: .sha256)

        // This should generate a valid JWT token
        let token = try await keyCollection.sign(payload)
        XCTAssertFalse(token.isEmpty)

        // The token should have 3 parts separated by dots
        let tokenParts = token.components(separatedBy: ".")
        XCTAssertEqual(tokenParts.count, 3)
    }

//    var checkoutPath: String {
//        if let path = ProcessInfo.processInfo.environment["PROJECT_PATH"] {
//            return path
//        }
//
//        XCTFail("PROJECT_PATH environment variable not set; cannot load fixtures")
//        return ""
//    }
//
//    func testLoadApplicationDefaultCredentials() throws {
//        let credentialFile = checkoutPath + "/Tests/GoogleCloudProviderTests/Fixtures/ADC.json"
//
//        XCTAssertNoThrow(try GoogleApplicationDefaultCredentials(contentsOfFile: credentialFile))
//
//        let creds = try GoogleApplicationDefaultCredentials(contentsOfFile: credentialFile)
//
//        XCTAssert(creds.clientId == "IDSTRING.apps.googleusercontent.com")
//        XCTAssert(creds.type == "authorized_user")
//    }
//
//    func testLoadServiceAccountCredentials() throws {
//        let credentialFile = checkoutPath + "/Tests/GoogleCloudProviderTests/Fixtures/ServiceAccount.json"
//
//        XCTAssertNoThrow(try GoogleServiceAccountCredentials(contentsOfFile: credentialFile))
//
//        let creds = try GoogleServiceAccountCredentials(contentsOfFile: credentialFile)
//
//        XCTAssert(creds.clientId == "CLIENTID")
//        XCTAssert(creds.type == "service_account")
//    }
//
//    static var allTests = [
//        ("testLoadApplicationDefaultCredentials", testLoadApplicationDefaultCredentials),
//        ("testLoadServiceAccount", testLoadServiceAccountCredentials)
//    ]
}