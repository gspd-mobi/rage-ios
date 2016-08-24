import XCTest

class RageRequestParamsTests: XCTestCase {

    var request: RageRequest!

    override func setUp() {
        super.setUp()
        let description = RequestDescription(httpMethod: .GET,
                                             baseUrl: "http://example.com",
                                             contentType: .Json,
                                             path: "someRequest",
                                             headers: [String: String]())
        let options = RequestOptions()
        let logger = Logger(logLevel: .None)
        request = RageRequest(requestDescription: description, options: options, logger: logger)
    }

    func testQueryParams() {
        var parameterRequest = request.query("berry", "cherry")
        XCTAssertEqual(parameterRequest.queryParameters.count, 1)
        XCTAssertEqual(parameterRequest.queryParameters["berry"], "cherry")

        var veg: String? = "carrot"
        parameterRequest = parameterRequest.query("vegetable", "carrot")
        XCTAssertEqual(parameterRequest.queryParameters.count, 2)
        XCTAssertEqual(parameterRequest.queryParameters["berry"], "cherry")
        XCTAssertEqual(parameterRequest.queryParameters["vegetable"], "carrot")

        parameterRequest = parameterRequest.query("berry", "raspberry")
        XCTAssertEqual(parameterRequest.queryParameters.count, 2)
        XCTAssertEqual(parameterRequest.queryParameters["berry"], "raspberry")
        XCTAssertEqual(parameterRequest.queryParameters["vegetable"], "carrot")

        veg = nil
        parameterRequest = parameterRequest.query("vegetable", veg)
        XCTAssertEqual(parameterRequest.queryParameters.count, 1)
        XCTAssertEqual(parameterRequest.queryParameters["berry"], "raspberry")
    }

}
