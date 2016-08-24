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
        let client = Rage.builderWithBaseUrl("http://example.com")
        XCTAssertEqual("http://example.com", client.baseUrl)
    }

    func testTimeoutSet() {
        let client = Rage.builderWithBaseUrl("http://example.com")
        .withTimeoutMillis(24 * 60 * 1000)
        XCTAssertEqual(client.timeoutMillis, 24 * 60 * 1000)
    }

    func testLogLevelSet() {
        let client = Rage.builderWithBaseUrl("http://example.com")
        .withLogLevel(.Medium)
        XCTAssertEqual(client.logLevel, LogLevel.Medium)
    }

    func testContentTypeSet() {
        let client = Rage.builderWithBaseUrl("http://example.com")
        .withContentType(.Custom("content-type"))
        XCTAssertEqual(client.contentType.stringValue(), "content-type")
    }

    func testHeaderSet() {
        let client = Rage.builderWithBaseUrl("http://example.com")
        .withHeader("Platform", "iOS")
        XCTAssertEqual(client.headers.count, 1)
        XCTAssertEqual(client.headers["Platform"], "iOS")
    }

    func testHeaderDictionarySet() {
        let client = Rage.builderWithBaseUrl("http://example.com")
        .withHeaderDictionary(["Platform": "iOS"])
        XCTAssertEqual(client.headers["Platform"], "iOS")
    }

}
