//
//  VisionTextToImageResponse.swift
//
//
//  Created by Kostis Stefanou on 12/9/24.
//

import Core
import Foundation

public struct VisionAnnotateImageResponse: GoogleCloudModel {
    public let responses: [VisionAnnotateImageResponseBody]
}

public struct VisionAnnotateImageResponseBody: GoogleCloudModel {
    public let textAnnotations: [TextAnnotation]
    public let fullTextAnnotation: FullTextAnnotation
}

public struct FullTextAnnotation: GoogleCloudModel {
    public let pages: [Page]
    public let text: String
}

public extension FullTextAnnotation {
    
    struct Page: GoogleCloudModel {
        public let property: WordProperty
        public let width, height: Int
        public let blocks: [Block]
    }
}

public extension FullTextAnnotation.Page {
    
    struct Block: GoogleCloudModel {
        public let boundingBox: Bounding
        public let paragraphs: [Paragraph]
        public let blockType: String
    }
}

public extension FullTextAnnotation.Page.Block {
    
    struct Paragraph: GoogleCloudModel {
        public let boundingBox: Bounding
        public let words: [Word]
    }
}

// MARK : - Common Models

public struct Word: GoogleCloudModel {
    public let property: WordProperty?
    public let boundingBox: Bounding
    public let symbols: [Symbol]
}

public struct WordProperty: GoogleCloudModel {
    public let detectedLanguages: [DetectedLanguage]
}

public struct Symbol: GoogleCloudModel {
    public let boundingBox: Bounding
    public let text: String
    public let property: SymbolProperty?
}

public struct SymbolProperty: GoogleCloudModel {
    let detectedBreak: DetectedBreak
}

public struct TextAnnotation: GoogleCloudModel {
    public let locale: String?
    public let description: String
    public let boundingPoly: Bounding
}

public struct Bounding: GoogleCloudModel {
    public let vertices: [Vertex]
}

public struct DetectedLanguage: GoogleCloudModel {
    public let languageCode: String
    public let confidence: Double
}

public struct Vertex: GoogleCloudModel {
    let x, y: Int
}

public struct DetectedBreak: GoogleCloudModel {
    public let type: String
}
