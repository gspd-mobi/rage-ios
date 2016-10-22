import Foundation
import Quick
import Nimble

class RageClientSpec: QuickSpec {

    // swiftlint:disable function_body_length
    override func spec() {
        describe("rage client can create requests") {

            let client = RageClient(defaultConfiguration:
                RageClientConfiguration(baseUrl: "http://example.com"))

            it("can make get request with no path") {
                let request = client.get()
                expect(request.httpMethod).to(equal(HttpMethod.get))
                expect(request.methodPath).to(beNil())
            }

            it("can make get request with path") {
                let request = client.get("/method")
                expect(request.httpMethod).to(equal(HttpMethod.get))
                expect(request.methodPath).to(equal("/method"))
            }

            it("can make post request with no path") {
                let request = client.post()
                expect(request.httpMethod).to(equal(HttpMethod.post))
                expect(request.methodPath).to(beNil())
            }

            it("can make post request with path") {
                let request = client.post("/method")
                expect(request.httpMethod).to(equal(HttpMethod.post))
                expect(request.methodPath).to(equal("/method"))
            }

            it("can make put request with no path") {
                let request = client.put()
                expect(request.httpMethod).to(equal(HttpMethod.put))
                expect(request.methodPath).to(beNil())
            }

            it("can make put request with path") {
                let request = client.put("/method")
                expect(request.httpMethod).to(equal(HttpMethod.put))
                expect(request.methodPath).to(equal("/method"))
            }

            it("can make delete request with no path") {
                let request = client.delete()
                expect(request.httpMethod).to(equal(HttpMethod.delete))
                expect(request.methodPath).to(beNil())
            }

            it("can make delete request with path") {
                let request = client.delete("/method")
                expect(request.httpMethod).to(equal(HttpMethod.delete))
                expect(request.methodPath).to(equal("/method"))
            }

            it("can make head request with no path") {
                let request = client.head()
                expect(request.httpMethod).to(equal(HttpMethod.head))
                expect(request.methodPath).to(beNil())
            }

            it("can make head request with path") {
                let request = client.head("/method")
                expect(request.httpMethod).to(equal(HttpMethod.head))
                expect(request.methodPath).to(equal("/method"))
            }

            it("can make patch request with no path") {
                let request = client.patch()
                expect(request.httpMethod).to(equal(HttpMethod.patch))
                expect(request.methodPath).to(beNil())
            }

            it("can make patch request with path") {
                let request = client.patch("/method")
                expect(request.httpMethod).to(equal(HttpMethod.patch))
                expect(request.methodPath).to(equal("/method"))
            }

            it("can make custom http method request with no path") {
                let request = client.customMethod("SOMECUSTOMHTTPMETHOD")
                expect(request.httpMethod).to(equal(HttpMethod.custom("SOMECUSTOMHTTPMETHOD",
                                                                      false)))
                expect(request.methodPath).to(beNil())
            }

            it("can make custom http method request with path") {
                let request = client.customMethod("SOMECUSTOMHTTPMETHOD", path: "/method")
                expect(request.httpMethod).to(equal(HttpMethod.custom("SOMECUSTOMHTTPMETHOD",
                                                                      false)))
                expect(request.methodPath).to(equal("/method"))
            }

        }

        describe("rage client can create requests with proper fields provided") {

            it("can create request with same configuration as client") {
                let config = RageClientConfiguration(baseUrl: "http://example.com")
                config.timeoutMillis = 999
                config.headers = ["a": "b", "c": "d"]
                config.contentType = ContentType.json
                let auth = TestAuthenticator()
                config.authenticator = auth
                let testPlugin = TestPlugin()
                config.plugins = [testPlugin]
                let testErrorHandler = TestErrorHandler()
                config.errorsHandlersClosure = {
                    [testErrorHandler]
                }
                let client = RageClient(defaultConfiguration: config)

                let request = client.createRequestWithHttpMethod(.get, path: "/method")

                expect(request.timeoutMillis).to(equal(999))

                expect(request.headers.count).to(equal(3))
                expect(request.headers["a"]).to(equal("b"))
                expect(request.headers["c"]).to(equal("d"))
                expect(request.headers["Content-Type"]).to(equal("application/json"))

                expect(request.authenticator).toNot(beNil())
                expect(request.plugins.count).to(equal(1))
                expect(request.errorHandlers.count).to(equal(1))
            }

        }
    }
}
