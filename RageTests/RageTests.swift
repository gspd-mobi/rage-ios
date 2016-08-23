import XCTest

class ParamsBuilderTests: XCTestCase {

    func testNoParams() {
        let url = ParamsBuilder.buildUrlString("http://example.com/api",
                                               path: "/someRequest",
                                               queryParameters: [String: String](),
                                               pathParameters: [String: String]())
        XCTAssertEqual(url, "http://example.com/api/someRequest")
    }

    func testOneQuery() {
        let url = ParamsBuilder.buildUrlString("http://example.com/api",
                                               path: "/someRequest",
                                               queryParameters: ["name": "Paul"],
                                               pathParameters: [String: String]())
        XCTAssertEqual(url, "http://example.com/api/someRequest?name=Paul")
    }

    func testMultipleQuery() {
        let url = ParamsBuilder.buildUrlString("http://example.com/api",
                                               path: "/someRequest",
                                               queryParameters: ["name": "Paul", "age": "24"],
                                               pathParameters: [String: String]())
        XCTAssertEqual(url, "http://example.com/api/someRequest?age=24&name=Paul")
    }

    func testPathParam() {
        let url = ParamsBuilder.buildUrlString("http://example.com/api",
                                               path: "/user/{userId}",
                                               queryParameters: [String: String](),
                                               pathParameters: ["userId": "5"])
        XCTAssertEqual(url, "http://example.com/api/user/5")
    }

    func testQueryEscaping() {
        let url = ParamsBuilder.buildUrlString("http://example.com/api",
                                               path: "/user",
                                               queryParameters: ["name": "paul k"],
                                               pathParameters: [String: String]())
        XCTAssertEqual(url, "http://example.com/api/user?name=paul%20k")
    }

    func testPathEscaping() {
        let url = ParamsBuilder.buildUrlString("http://example.com/api",
                                               path: "/user/{name}",
                                               queryParameters: [String: String](),
                                               pathParameters: ["name": "paul k"])
        XCTAssertEqual(url, "http://example.com/api/user/paul%20k")
    }

}

class RageClientTests: XCTestCase {

    func testNoUrlClient() {
        Rage.builder().build()
    }

}
