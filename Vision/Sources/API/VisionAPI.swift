//
//  VisionAPI.swift
//
//
//  Created by Kostis Stefanou on 12/9/24.
//

import AsyncHTTPClient
import NIO
import Core
import Foundation

public protocol VisionAPI {
    func annotateImages(_ imageRequests: [AnnotateImageRequest]) -> EventLoopFuture<VisionAnnotateImageResponse>
}

public extension VisionAPI {
    func annotateImage(_ imageRequest: AnnotateImageRequest) -> EventLoopFuture<VisionAnnotateImageResponse> {
        annotateImages([imageRequest])
    }
}

public final class GoogleCloudVisionAPI: VisionAPI {
    
    let endpoint: String
    let request: GoogleCloudVisionRequest
    let encoder = JSONEncoder()
    
    init(request: GoogleCloudVisionRequest,
         endpoint: String) {
        self.request = request
        self.endpoint = endpoint
    }
    
    private var annotateImagesPath: String {
        "\(endpoint)/v1/images:annotate"
    }
    
    public func annotateImages(_ imageRequests: [AnnotateImageRequest]) -> EventLoopFuture<VisionAnnotateImageResponse> {
        do {
            let bodyDict = [
                "requests": [imageRequests]
            ]
           
            let body = try HTTPClient.Body.data(encoder.encode(bodyDict))
            return request.send(method: .POST, path: annotateImagesPath, body: body)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
}
