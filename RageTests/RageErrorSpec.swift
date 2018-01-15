import Foundation
import Quick
import Nimble

class RageErrorSpec: QuickSpec {

    override func spec() {
        describe("rage error") {
            describe("can be initialised") {
                describe("with type and response") {
                    let errorType = RageErrorType.raw
                    let request = RageRequest(httpMethod: .get, baseUrl: nil, session: URLSession.shared)
                    let response = RageResponse(request: request, data: nil, response: nil, error: nil)
                    let error = RageError(type: errorType, rageResponse: response)
                    it("type set") {
                        expect(error.type).to(equal(RageErrorType.raw))
                    }
                    it("response set") {
                        expect(error.rageResponse).notTo(beNil())
                    }
                    it("message not set") {
                        expect(error.message).to(beNil())
                    }
                }
                describe("with type and message") {
                    let errorType = RageErrorType.networkError
                    let error = RageError(type: errorType, message: "error message")
                    it("type set") {
                        expect(error.type).to(equal(RageErrorType.networkError))
                    }
                    it("response not set") {
                        expect(error.rageResponse).to(beNil())
                    }
                    it("message set") {
                        expect(error.message).to(equal("error message"))
                    }
                }
                describe("with response only") {
                    let url = URL(string: "http://example.com")!
                    let urlResponse = URLResponse(url: url, mimeType: "application/json", expectedContentLength: 1234, textEncodingName: "utf-8")
                    let request = RageRequest(httpMethod: .get, baseUrl: nil, session: URLSession.shared)
                    [NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet].forEach { code in
                        let error = NSError(domain: NSURLErrorDomain, code: code, userInfo: nil)
                        let response = RageResponse(request: request, data: nil, response: urlResponse, error: error)
                        let rageError = RageError(response: response)
                        it("network error with code \(code) set") {
                            expect(rageError.type).to(equal(RageErrorType.networkError))
                        }
                    }
                    it("http error type set") {
                        let response = RageResponse(request: request, data: nil, response: urlResponse, error: nil)
                        let rageError = RageError(response: response)
                        expect(rageError.type).to(equal(RageErrorType.http))
                    }
                    it("raw type set by default") {
                        let error = NSError(domain: "any", code: 123, userInfo: nil)
                        let response = RageResponse(request: request, data: nil, response: urlResponse, error: error)
                        let rageError = RageError(response: response)
                        expect(rageError.type).to(equal(RageErrorType.raw))
                    }
                }
            }
            describe("status code got from response") {
                it("is null if no response") {
                    let error = RageError(type: .raw)
                    expect(error.statusCode()).to(beNil())
                }
                it("is equal to response status code") {
                    let request = RageRequest(httpMethod: .get, baseUrl: nil, session: URLSession.shared)
                    let error = NSError(domain: "domain", code: 404, userInfo: nil)
                    let response = RageResponse(request: request, data: nil, response: nil, error: error)
                    let rageError = RageError(type: .http, rageResponse: response)
                    expect(rageError.statusCode()).to(equal(404))
                }
            }
        }
    }

}

