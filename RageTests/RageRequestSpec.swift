import Foundation
import Quick
import Nimble

class RageRequestSpec: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable line_length
    override func spec() {
        describe("rage request") {

            var baseUrl: String!
            var method: HttpMethod!
            var request: RageRequest!
            beforeEach {
                baseUrl = "http://example.com"
                method = HttpMethod.get
                request = RageRequest(httpMethod: method, baseUrl: baseUrl)
            }

            describe("customization") {
                it("can set url") {
                    _ = request.url("http://example2.com")
                    expect(request.baseUrl).to(equal("http://example2.com"))
                }

                it("can add 1 query parameter") {
                    expect(request.queryParameters.count).to(equal(0))
                    _ = request.query("name", "Paul")
                    expect(request.queryParameters.count).to(equal(1))
                    expect(request.queryParameters["name"]).to(equal("Paul"))
                }

                it("can add 2 query parameters") {
                    expect(request.queryParameters.count).to(equal(0))
                    _ = request.query("name", "Paul")
                        .query("age", 24)
                    expect(request.queryParameters.count).to(equal(2))
                    expect(request.queryParameters["name"]).to(equal("Paul"))
                    expect(request.queryParameters["age"]).to(equal("24"))
                }

                it("can remove query parameter") {
                    expect(request.queryParameters.count).to(equal(0))
                    _ = request.query("name", "Paul")
                        .query("age", 24)
                    expect(request.queryParameters.count).to(equal(2))
                    expect(request.queryParameters["name"]).to(equal("Paul"))
                    expect(request.queryParameters["age"]).to(equal("24"))
                    let newAge: Int? = nil
                    _ = request.query("age", newAge)
                    expect(request.queryParameters.count).to(equal(1))
                    expect(request.queryParameters["age"]).to(beNil())
                }

                it("can add 2 query parameters with dictionary") {
                    expect(request.queryParameters.count).to(equal(0))
                    _ = request.queryDictionary(["name": "Paul", "age": "24"])
                    expect(request.queryParameters.count).to(equal(2))
                    expect(request.queryParameters["name"]).to(equal("Paul"))
                    expect(request.queryParameters["age"]).to(equal("24"))
                }

                it("can add 2 query parameters with dictionary and remove 1") {
                    expect(request.queryParameters.count).to(equal(0))
                    _ = request.queryDictionary(["name": "Paul", "age": "24"])
                    expect(request.queryParameters.count).to(equal(2))
                    expect(request.queryParameters["name"]).to(equal("Paul"))
                    expect(request.queryParameters["age"]).to(equal("24"))
                    let newAge: Int? = nil
                    _ = request.queryDictionary(["age": newAge])
                    expect(request.queryParameters.count).to(equal(1))
                    expect(request.queryParameters["age"]).to(beNil())
                }

                it("can add 1 path parameter") {
                    expect(request.pathParameters.count).to(equal(0))
                    _ = request.path("name", "Paul")
                    expect(request.pathParameters.count).to(equal(1))
                    expect(request.pathParameters["name"]).to(equal("Paul"))
                }

                it("can add 2 path parameters") {
                    expect(request.pathParameters.count).to(equal(0))
                    _ = request.path("name", "Paul")
                        .path("age", 24)
                    expect(request.pathParameters.count).to(equal(2))
                    expect(request.pathParameters["name"]).to(equal("Paul"))
                    expect(request.pathParameters["age"]).to(equal("24"))
                }

                it("can add 1 header") {
                    expect(request.headers.count).to(equal(0))
                    _ = request.header("Authorization", "Basic abcd")
                    expect(request.headers.count).to(equal(1))
                    expect(request.headers["Authorization"]).to(equal("Basic abcd"))
                }

                it("can add 2 header") {
                    expect(request.headers.count).to(equal(0))
                    _ = request.header("Authorization", "Basic abcd")
                        .header("Api-Version", 5)
                    expect(request.headers.count).to(equal(2))
                    expect(request.headers["Authorization"]).to(equal("Basic abcd"))
                    expect(request.headers["Api-Version"]).to(equal("5"))
                }

                it("can remove header") {
                    expect(request.headers.count).to(equal(0))
                    _ = request.header("Authorization", "Basic abcd")
                        .header("Api-Version", 5)
                    expect(request.headers.count).to(equal(2))
                    expect(request.headers["Authorization"]).to(equal("Basic abcd"))
                    expect(request.headers["Api-Version"]).to(equal("5"))
                    let newVersion: Int? = nil
                    _ = request.header("Api-Version", newVersion)
                    expect(request.headers.count).to(equal(1))
                    expect(request.headers["Api-Version"]).to(beNil())
                }

                it("can add 2 headers with dictionary") {
                    expect(request.headers.count).to(equal(0))
                    _ = request.headerDictionary(["Authorization": "Basic abcd", "Api-Version": "5"])
                    expect(request.headers.count).to(equal(2))
                    expect(request.headers["Authorization"]).to(equal("Basic abcd"))
                    expect(request.headers["Api-Version"]).to(equal("5"))
                    let newVersion: Int? = nil
                    _ = request.header("Api-Version", newVersion)
                    expect(request.headers.count).to(equal(1))
                    expect(request.headers["Api-Version"]).to(beNil())
                }

                it("can add 2 headers with dictionary and remove 1") {
                    expect(request.headers.count).to(equal(0))
                    _ = request.headerDictionary(["Authorization": "Basic abcd", "Api-Version": "5"])
                    expect(request.headers.count).to(equal(2))
                    expect(request.headers["Authorization"]).to(equal("Basic abcd"))
                    expect(request.headers["Api-Version"]).to(equal("5"))
                    let newVersion: Int? = nil
                    _ = request.headerDictionary(["Api-Version": newVersion])
                    expect(request.headers.count).to(equal(1))
                    expect(request.headers["Api-Version"]).to(beNil())
                }

                it("can set content type") {
                    expect(request.headers.count).to(equal(0))
                    _ = request.contentType(.json)
                    expect(request.headers["Content-Type"]).to(equal("application/json"))
                    _ = request.contentType(.urlEncoded)
                    expect(request.headers["Content-Type"]).to(equal("application/x-www-form-urlencoded"))
                    _ = request.contentType(.multipartFormData)
                    expect(request.headers["Content-Type"]).to(equal("multipart/form-data"))
                    _ = request.contentType(.custom("image/png"))
                    expect(request.headers["Content-Type"]).to(equal("image/png"))
                }

                it("can be authorized with client authenticator") {
                    let auth = TestAuthenticator()
                    request.authenticator = auth
                    _ = request.authorized()
                    expect(request.authenticator).toNot(beNil())
                }

                it("can be authorized with request authenticator") {
                    let auth = TestAuthenticator()
                    _ = request.authorized(auth)
                    expect(request.authenticator).toNot(beNil())
                }
            }

            describe("stub") {
                it("can be stubbed with data") {
                    expect(request.stubData).to(beNil())
                    let stubString = "{}"
                    let stubData = stubString.data(using: String.Encoding.utf8)!
                    _ = request.stub(stubData)
                    expect(request.stubData).toNot(beNil())
                    expect(String(data: request.stubData!.data, encoding: String.Encoding.utf8)).to(equal("{}"))
                    expect(request.stubData!.mode).to(equal(StubMode.immediate))
                }

                it("can be stubbed with string") {
                    expect(request.stubData).to(beNil())
                    let stubString = "{}"
                    _ = request.stub(stubString)
                    expect(request.stubData).toNot(beNil())
                    expect(String(data: request.stubData!.data, encoding: String.Encoding.utf8)).to(equal("{}"))
                    expect(request.stubData!.mode).to(equal(StubMode.immediate))
                }

                it("can be stubbed with never stub mode") {
                    expect(request.stubData).to(beNil())
                    let stubString = "{}"
                    _ = request.stub(stubString, mode: .never)
                    expect(request.stubData).toNot(beNil())
                    expect(String(data: request.stubData!.data, encoding: String.Encoding.utf8)).to(equal("{}"))
                    expect(request.stubData!.mode).to(equal(StubMode.never))
                }

                it("can be stubbed with delayed stub mode") {
                    expect(request.stubData).to(beNil())
                    let stubString = "{}"
                    _ = request.stub(stubString, mode: .delayed(2014))
                    expect(request.stubData).toNot(beNil())
                    expect(String(data: request.stubData!.data, encoding: String.Encoding.utf8)).to(equal("{}"))
                    expect(request.stubData!.mode).to(equal(StubMode.delayed(2014)))
                    expect(request.stubData!.mode).toNot(equal(StubMode.delayed(1000)))
                }
            }
        }
    }
}
