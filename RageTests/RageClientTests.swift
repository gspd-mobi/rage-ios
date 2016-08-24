import XCTest

class RageClientTests: XCTestCase {

    func testClientCreateRequest() {
        let client = RageClient(baseUrl: "http://example.com",
                            contentType: .Json,
                            logLevel: .Full,
                            timeoutMillis: 2 * 1000,
                            headers: ["a":"b", "c":"d"]
        )
        let request = client.get("/someRequest")
        XCTAssertEqual(request.baseUrl, client.baseUrl)
        XCTAssertEqual(request.contentType.stringValue(), client.contentType.stringValue())
        XCTAssertEqual(request.timeoutMillis, client.timeoutMillis)
        XCTAssertEqual(request.logger.logLevel, client.logLevel)

        XCTAssertEqual(request.headers.count, client.headers.count)
        var matchedHeaders = 0
        client.headers.forEach {
            (key, value) in
            if request.headers[key] == value {
                matchedHeaders += 1
            }
        }
        XCTAssertEqual(matchedHeaders, client.headers.count)
    }

}
