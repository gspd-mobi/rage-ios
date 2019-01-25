import Foundation
import Quick
import Nimble

class BodyRageRequestSpec: QuickSpec {

    override func spec() {
        describe("body rage request") {
            it("body can be set as data") {
                let request = BodyRageRequest(httpMethod: .post, baseUrl: "http://example.com")
                let initialData = "{}".utf8Data()!
                let bodyRequest = request.bodyData(initialData)
                expect(bodyRequest.body).to(equal(initialData))
            }
            it("body can be set as string") {
                let request = BodyRageRequest(httpMethod: .post, baseUrl: "http://example.com")
                let string = "{}"
                let bodyRequest = request.bodyString(string)
                expect(bodyRequest.body?.utf8String()).to(equal(string))
            }
        }
    }

}
