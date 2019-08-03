//
//  ServiceAccount.swift
//  Async
//
//  Created by Brian Hatfield on 7/17/18.
//

import Foundation

// Loads credentials from a file specified in env:GOOGLE_APPLICATION_CREDENTIALS
//
// Example JSON:
//
//    {
//        "type": "service_account",
//        "project_id": "PROJECTID",
//        "private_key_id": "PRIVATEKEYID",
//        "private_key": "-----BEGIN PRIVATE KEY-----\nPEMPRIVATEKEY\n-----END PRIVATE KEY-----\n",
//        "client_email": "SERVICEACCOUNTNAME@PROJECTID.iam.gserviceaccount.com",
//        "client_id": "CLIENTID",
//        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//        "token_uri": "https://accounts.google.com/o/oauth2/token",
//        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/SERVICEACCOUNTNAME%40PROJECTID.iam.gserviceaccount.com"
//    }

struct GoogleServiceAccountCredentials: Codable {
    let type: String
    let projectId: String
    let privateKeyId: String
    let privateKey: String
    let clientEmail: String
    let clientId: String

    let authUri: URL
    let tokenUri: URL
    let authProviderX509CertUrl: URL
    let clientX509CertUrl: URL

    enum CodingKeys: String, CodingKey {
        case type
        case projectId = "project_id"
        case privateKeyId = "private_key_id"
        case privateKey = "private_key"
        case clientEmail = "client_email"
        case clientId = "client_id"
        case authUri = "auth_uri"
        case tokenUri = "token_uri"
        case authProviderX509CertUrl = "auth_provider_x509_cert_url"
        case clientX509CertUrl = "client_x509_cert_url"
    }
}

