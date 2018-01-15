import Foundation
import Quick
import Nimble

class MultipartRageRequestSpec: QuickSpec {

    override func spec() {
        describe("multipart rage request") {
            it("part can be added") {
                let request = RageRequest(httpMethod: .post, baseUrl: "http://example.com")
                    .multipart()
                    .part(TypedObject(Data(), mimeType: "image/png"), name: "key1")
                expect(request.parts.count).to(equal(1))
                expect(request.parts[0].name).to(equal("key1"))
            }
            it("part can be removed") {
                let request = RageRequest(httpMethod: .post, baseUrl: "http://example.com")
                    .multipart()
                    .part(TypedObject(Data(), mimeType: "image/png"), name: "key1")
                    .part(nil, name: "key1")
                expect(request.parts.count).to(equal(0))
            }
            it("custom boundary can be set") {
                let request = RageRequest(httpMethod: .post, baseUrl: "http://example.com")
                    .multipart()
                    .boundary("customBoundary123456")
                expect(request.customBoundary).to(equal("customBoundary123456"))
            }
        }
    }

}
