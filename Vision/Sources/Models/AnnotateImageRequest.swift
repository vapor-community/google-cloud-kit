//
//  AnnotateImageRequest.swift
//
//
//  Created by Kostis Stefanou on 12/9/24.
//

import Foundation

public struct AnnotateImageRequest: Encodable {
    
    public let image: Image
    public let features: [Feature]
    
    public init(image: Image, features: [Feature]) {
        self.image = image
        self.features = features
    }
    
    public init(imageUri: String) {
        self.image = .init(source: .init(imageUri: imageUri))
        self.features = [.init(type: .textDetection)]
    }
}

// MARK: - Image

public extension AnnotateImageRequest {
    
    struct Image: Encodable {
        let source: ImageResource
    }
}

// MARK: - ImageResource

extension AnnotateImageRequest.Image {
    
    struct ImageResource: Encodable {
        let imageUri: String
    }
}

// MARK: - Feature

public extension AnnotateImageRequest {
    
    struct Feature: Encodable {
        
        enum FeatureType: String, Encodable {
            case textDetection = "TEXT_DETECTION"
        }
        
        let type: FeatureType
    }
}
