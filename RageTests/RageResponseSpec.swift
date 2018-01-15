import Foundation
import Quick
import Nimble

class RageResponseSpec: QuickSpec {

    override func spec() {
        describe("response") {
            let urlString = "http://example.com"
            let url = URL(string: urlString)!
            it("status code got from inner response") {
                let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
                let request = RageRequest(httpMethod: .get, baseUrl: urlString)
                let rageResponse = RageResponse(request: request, data: nil, response: response, error: nil)
                expect(rageResponse.statusCode()).to(equal(404))
            }
            it("status code got from error if response is not http") {
                let error = NSError(domain: "domain", code: 502, userInfo: nil)
                let request = RageRequest(httpMethod: .get, baseUrl: urlString)
                let rageResponse = RageResponse(request: request, data: nil, response: nil, error: error)
                expect(rageResponse.statusCode()).to(equal(502))
            }
            it("status code is nil if there is no response or error") {
                let request = RageRequest(httpMethod: .get, baseUrl: urlString)
                let rageResponse = RageResponse(request: request, data: nil, response: nil, error: nil)
                expect(rageResponse.statusCode()).to(beNil())
            }
            describe("response is successfull when status code is in 200..<300") {
                it("200") {
                    let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
                    let request = RageRequest(httpMethod: .get, baseUrl: urlString)
                    let successResponse = RageResponse(request: request, data: nil, response: response, error: nil)
                    expect(successResponse.isSuccess()).to(equal(true))
                }
                it("201") {
                    let response = HTTPURLResponse(url: url, statusCode: 201, httpVersion: nil, headerFields: nil)
                    let request = RageRequest(httpMethod: .get, baseUrl: urlString)
                    let successResponse = RageResponse(request: request, data: nil, response: response, error: nil)
                    expect(successResponse.isSuccess()).to(equal(true))
                }
                it("300") {
                    let response = HTTPURLResponse(url: url, statusCode: 300, httpVersion: nil, headerFields: nil)
                    let request = RageRequest(httpMethod: .get, baseUrl: urlString)
                    let successResponse = RageResponse(request: request, data: nil, response: response, error: nil)
                    expect(successResponse.isSuccess()).to(equal(false))
                }
                it("no status code") {
                    let request = RageRequest(httpMethod: .get, baseUrl: urlString)
                    let rageResponse = RageResponse(request: request, data: nil, response: nil, error: nil)
                    expect(rageResponse.isSuccess()).to(equal(false))
                }
            }
        }
    }

}
