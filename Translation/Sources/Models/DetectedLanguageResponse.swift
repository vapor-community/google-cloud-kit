//
//  DetectedLanguageResponse.swift
//  
//
//  Created by Andrew Edwards on 2/20/22.
//

import Foundation

public struct DetectedLanguageResponse: Codable {
    /// The list of language detection responses. This list will contain a language detection response for each query (q) sent in the language detection request.
    public var data: DetectedLanguageResponseList
}

/// A response list contains a list of separate language detection responses.
public struct DetectedLanguageResponseList: Codable {
    /// Language detection results for each input text piece.
    public var detections: [DetectedLanguage]
}

public struct DetectedLanguage: Codable {
    /// The detected language
    public var language: String
}
