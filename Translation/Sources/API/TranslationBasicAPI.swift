import AsyncHTTPClient
import NIO
import Core
import Foundation

public protocol TranslationBasicAPI {
    func translate(text: String,
                   target: String,
                   format: TranslationFormat,
                   source: String?) async throws -> TranslationResponse
    
    func detect(text: String) async throws -> DetectedLanguageResponse
    
    func languages(target: String?) async throws -> LanguageResponse
}

public extension TranslationBasicAPI {
    /// Translates input text, returning translated text.
    /// - Parameters:
    ///   - text: The input text to translate. Provide an array of strings to translate multiple phrases. The maximum number of strings is 128.
    ///   - target: The language to use for translation of the input text, set to one of the language codes listed in Language Support.
    ///   - format: The format of the source text, in either `HTML` (default) or `plain-text`. A value of `html` indicates HTML and a value of `text` indicates plain-text.
    ///   - source: The language of the source text, set to one of the language codes listed in Language Support. If the source language is not specified, the API will attempt to detect the source language automatically and return it within the response.
    /// - Returns: `TranslationResponse`
    func translate(text: String,
                   target: String,
                   format: TranslationFormat = .text,
                   source: String? = nil) async throws -> TranslationResponse {
        try await translate(text: text, target: target, format: format, source: source)
    }
    
    /// Detects the language of text within a request.
    /// - Parameter text: The input text upon which to perform language detection. Repeat this parameter to perform language detection on multiple text inputs.
    /// - Returns: `DetectedLanguageResponse`
    func detect(text: String) async throws -> DetectedLanguageResponse {
        try await detect(text: text)
    }
    
    /// Returns a list of supported languages for translation.
    /// - Parameter target: The target language code for the results. If specified, then the language names are returned in the name field of the response, localized in the target language. If you do not supply a target language, then the name field is omitted from the response and only the language codes are returned.
    /// - Returns: `LanguageResponse`
    func languages(target: String? = nil) async throws -> LanguageResponse {
        try await languages(target: target)
    }
}

public final class GoogleCloudTranslationBasicAPI: TranslationBasicAPI {
    let endpoint: String
    let request: GoogleCloudTranslationRequest
    
    init(request: GoogleCloudTranslationRequest,
         endpoint: String) {
        self.request = request
        self.endpoint = endpoint
    }
    
    private var translationPath: String {
        "\(endpoint)/language/translate/v2"
    }

    public func translate(text: String,
                          target: String,
                          format: TranslationFormat = .text,
                          source: String? = nil) async throws -> TranslationResponse {
        var body = [
            "q": text,
            "target": target,
            "format": format.rawValue
        ]
        if let source = source {
            body["source"] = source
        }
        
        return try await request.send(method: .POST, path: "\(endpoint)/language/translate/v2", query: body.queryParameters)
    }
    
    public func detect(text: String) async throws -> DetectedLanguageResponse {
        try await request.send(method: .POST, path: "\(endpoint)/language/translate/v2/detect", query: ["q": text].queryParameters)
    }
    
    public func languages(target: String? = nil) async throws -> LanguageResponse {
        var body: [String: Any] = [:]
        if let target = target {
            body["target"] = target
        }
        
        return try await request.send(method: .GET, path: "\(endpoint)/language/translate/v2/languages", query: body.queryParameters)
    }
}
