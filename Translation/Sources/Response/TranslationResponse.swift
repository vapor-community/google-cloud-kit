import Core

public struct TranslationResponse: GoogleCloudModel {
    public let data: TranslationData
}

public struct TranslationData: GoogleCloudModel {
    public let translations: [Translation]
}

public struct Translation: GoogleCloudModel {
    public let translatedText: String
    public let detectedLanguageCode: String?
}
