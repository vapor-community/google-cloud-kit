import Foundation

public struct TranslationResponse: Codable {
    /// The list of language translation responses. This list contains a language translation response for each query (q) sent in the language translation request.
    public var data: TranslationResponseList
}

/// A response list contains a list of separate language translation responses.
public struct TranslationResponseList: Codable {
    /// Contains list of translation results of the supplied text.
    public var translations: [TranslationTextResponse]
}

/// Contains a list of translation results for the requested text.
public struct TranslationTextResponse: Codable {
    /// The source language of the initial request, detected automatically, if no source language was passed within the initial request. If the source language was passed, auto-detection of the language will not occur and this field will be omitted.
    public var detectedLanguageCode: String?
    /// The translation model. Cloud Translation - Basic offers only the nmt Neural Machine Translation (NMT) model.
    public var model: String?
    /// Text translated into the target language.
    public var translatedText: String
}

public enum TranslationFormat: String, Codable {
    case html
    case text
}
