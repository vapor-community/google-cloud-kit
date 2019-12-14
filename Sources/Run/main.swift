//
//  main.swift
//  
//
//  Created by Andrew Edwards on 12/11/19.
//
// FOR TESTING
//
//import Foundation
//import Storage
//import Core
//import AsyncHTTPClient
//import NIO
//
//let elg = MultiThreadedEventLoopGroup(numberOfThreads: 1)
//let client = HTTPClient(eventLoopGroupProvider: .shared(elg),
//                        configuration: .init(ignoreUncleanSSLShutdown: true))
//do {
//    let credentialsConfiguration = try GoogleCloudCredentialsConfiguration()
//
//    let cloudStorageConfiguration: GoogleCloudStorageConfiguration = .default()
//    let gcs = try GoogleCloudStorageClient(credentials: credentialsConfiguration,
//                                            storageConfig: cloudStorageConfiguration,
//                                            httpClient: client,
//                                            eventLoop: elg.next())
//
//
//    let bucket = try gcs.buckets.insert(name: "nio-cloud-storage-demo").wait()
//
//    print(bucket.selfLink)
//
//} catch {
//    print(error)
//}
//try? client.syncShutdown()
