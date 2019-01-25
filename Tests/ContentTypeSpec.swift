import Foundation
import Quick
import Nimble

class ContentTypeSpec: QuickSpec {

    override func spec() {
        describe("content type") {
            describe("string value") {
                it("json") {
                    let contentType = ContentType.json
                    expect(contentType.stringValue()).to(equal("application/json"))
                }
                it("url encoded") {
                    let contentType = ContentType.urlEncoded
                    expect(contentType.stringValue()).to(equal("application/x-www-form-urlencoded"))
                }
                it("multipart form data") {
                    let contentType = ContentType.multipartFormData
                    expect(contentType.stringValue()).to(equal("multipart/form-data"))
                }
                it("custom") {
                    let contentType = ContentType.custom("custom content type")
                    expect(contentType.stringValue()).to(equal("custom content type"))
                }
            }
        }
    }

}
