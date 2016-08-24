import XCTest

extension LogLevel: Equatable {
}

public func == (lhs: LogLevel, rhs: LogLevel) -> Bool {
    switch (lhs, rhs) {
    case (.None, .None):
        return true
    case (.Medium, .Medium):
        return true
    case (.Full, .Full):
        return true
    default:
        return false
    }
}

class RageTests: XCTestCase {

    func testClientBaseUrl() {
        let builder = Rage.builderWithBaseUrl("http://example.com")
        XCTAssertEqual("http://example.com", builder.baseUrl)
    }

    func testTimeoutSet() {
        let builder = Rage.builderWithBaseUrl("http://example.com")
        .withTimeoutMillis(24 * 60 * 1000)
        XCTAssertEqual(builder.timeoutMillis, 24 * 60 * 1000)
    }

    func testLogLevelSet() {
        let builder = Rage.builderWithBaseUrl("http://example.com")
        .withLogLevel(.Medium)
        XCTAssertEqual(builder.logLevel, LogLevel.Medium)
    }

    func testContentTypeSet() {
        let builder = Rage.builderWithBaseUrl("http://example.com")
        .withContentType(.Custom("content-type"))
        XCTAssertEqual(builder.contentType.stringValue(), "content-type")
    }

    func testHeaderSet() {
        let builder = Rage.builderWithBaseUrl("http://example.com")
        .withHeader("Platform", "iOS")
        XCTAssertEqual(builder.headers.count, 1)
        XCTAssertEqual(builder.headers["Platform"], "iOS")
    }

    func testHeaderDictionarySet() {
        let builder = Rage.builderWithBaseUrl("http://example.com")
        .withHeaderDictionary(["Platform": "iOS"])
        XCTAssertEqual(builder.headers.count, 1)
        XCTAssertEqual(builder.headers["Platform"], "iOS")
    }

    func testSuccessfulBuild() {
        let client = Rage.builderWithBaseUrl("https://example.com")
        .withTimeoutMillis(24 * 60 * 1000)
        .withLogLevel(.Full)
        .withContentType(.Json)
        .withHeader("Platform", "iOS")
        .withHeaderDictionary(["Platform-Version": "9.3", "Api-Version": "2.0"])
        .build()

        XCTAssertEqual(client.baseUrl, "https://example.com")
        XCTAssertEqual(client.logLevel, LogLevel.Full)
        XCTAssertEqual(client.contentType.stringValue(), "application/json")
        XCTAssertEqual(client.headers.count, 3)
        XCTAssertEqual(client.headers["Api-Version"], "2.0")
    }

}
