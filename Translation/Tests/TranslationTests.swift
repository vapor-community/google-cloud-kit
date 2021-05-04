import XCTest
@testable import Translation
import Core
import AsyncHTTPClient
import NIO

class TranslationTests: XCTestCase {
    var elg: MultiThreadedEventLoopGroup!
    var client: HTTPClient!

    override func setUp() {
        super.setUp()
        elg = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        client = HTTPClient(eventLoopGroupProvider: .shared(elg),
                            configuration: .init(ignoreUncleanSSLShutdown: true))
    }

    //Just for manual testing purposes.
//    func testAPI() {
//        do {
//            let credentialsConfig = try GoogleCloudCredentialsConfiguration()
//            let translationConfig = GoogleCloudTranslationConfiguration.default()
//
//            let gct = try GoogleCloudTranslationClient(credentials: credentialsConfig,
//                                                       config: translationConfig,
//                                                       httpClient: client,
//                                                       eventLoop: elg.next())
//
//            let translation = gct.translation.translate(text: "Is this working?.", target: "es")
//
//            let content = try translation.wait()
//
//            print(content.data.translations.first!.translatedText)
//            XCTAssertEqual(content.data.translations.count, 1)
//        }
//        catch {
//            XCTFail(error.localizedDescription)
//        }
//    }
}
