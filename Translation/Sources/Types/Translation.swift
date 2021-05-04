import Core

public struct Translation: GoogleCloudModel {
    public let translatedText: String
    public let detectedLanguageCode: String?
}
