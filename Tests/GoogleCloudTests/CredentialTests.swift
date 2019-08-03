//
//  CredentialTests.swift
//  Async
//
//  Created by Brian Hatfield on 7/17/18.
//

import Foundation
import XCTest

@testable import GoogleCloud

final class CredentialTests: XCTestCase {
    var checkoutPath: String {
        if let path = ProcessInfo.processInfo.environment["PROJECT_PATH"] {
            return path
        }

        XCTFail("PROJECT_PATH environment variable not set; cannot load fixtures")
        return ""
    }

    func testLoadApplicationDefaultCredentials() throws {
        let credentialFile = checkoutPath + "/Tests/GoogleCloudProviderTests/Fixtures/ADC.json"

        XCTAssertNoThrow(try GoogleApplicationDefaultCredentials(contentsOfFile: credentialFile))

        let creds = try GoogleApplicationDefaultCredentials(contentsOfFile: credentialFile)

        XCTAssert(creds.clientId == "IDSTRING.apps.googleusercontent.com")
        XCTAssert(creds.type == "authorized_user")
    }

    func testLoadServiceAccountCredentials() throws {
        let credentialFile = checkoutPath + "/Tests/GoogleCloudProviderTests/Fixtures/ServiceAccount.json"

        XCTAssertNoThrow(try GoogleServiceAccountCredentials(contentsOfFile: credentialFile))

        let creds = try GoogleServiceAccountCredentials(contentsOfFile: credentialFile)

        XCTAssert(creds.clientId == "CLIENTID")
        XCTAssert(creds.type == "service_account")
    }

    static var allTests = [
        ("testLoadApplicationDefaultCredentials", testLoadApplicationDefaultCredentials),
        ("testLoadServiceAccount", testLoadServiceAccountCredentials)
    ]
}
