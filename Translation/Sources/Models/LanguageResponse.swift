//
//  LanguageResponse.swift
//  
//
//  Created by Andrew Edwards on 2/25/22.
//

import Foundation

public struct LanguageResponse: Codable {
    /// A list of supported language responses. This list will contain an entry for each language supported by the Translation API.
    public var data: LanguageResponseList
}

/// A response list contains a list of separate supported language responses.
public struct LanguageResponseList: Codable {
    /// The set of supported languages.
    public var languages: [LanguageResponseLanguage]
}

/// A single supported language response corresponds to information related to one supported language.
public struct LanguageResponseLanguage: Codable {
    /// Supported language code
    public var language: String
    /// Human readable name of the language localized to the target language.
    public var name: String
}
