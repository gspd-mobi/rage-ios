import Foundation
import Quick
import Nimble

class HttpMethodTypeSpec: QuickSpec {

    override func spec() {
        describe("http method") {
            describe("string value") {
                it("get") {
                    let method = HttpMethod.get
                    expect(method.stringValue()).to(equal("GET"))
                }
                it("post") {
                    let method = HttpMethod.post
                    expect(method.stringValue()).to(equal("POST"))
                }
                it("put") {
                    let method = HttpMethod.put
                    expect(method.stringValue()).to(equal("PUT"))
                }
                it("delete") {
                    let method = HttpMethod.delete
                    expect(method.stringValue()).to(equal("DELETE"))
                }
                it("patch") {
                    let method = HttpMethod.patch
                    expect(method.stringValue()).to(equal("PATCH"))
                }
                it("head") {
                    let method = HttpMethod.head
                    expect(method.stringValue()).to(equal("HEAD"))
                }
                it("custom") {
                    let method = HttpMethod.custom("custom", false)
                    expect(method.stringValue()).to(equal("custom"))
                }
            }
            describe("has body") {
                it("get") {
                    let method = HttpMethod.get
                    expect(method.hasBody()).to(equal(false))
                }
                it("post") {
                    let method = HttpMethod.post
                    expect(method.hasBody()).to(equal(true))
                }
                it("put") {
                    let method = HttpMethod.put
                    expect(method.hasBody()).to(equal(true))
                }
                it("delete") {
                    let method = HttpMethod.delete
                    expect(method.hasBody()).to(equal(true))
                }
                it("patch") {
                    let method = HttpMethod.patch
                    expect(method.hasBody()).to(equal(true))
                }
                it("head") {
                    let method = HttpMethod.head
                    expect(method.hasBody()).to(equal(false))
                }
                it("custom with body") {
                    let method = HttpMethod.custom("custom", true)
                    expect(method.hasBody()).to(equal(true))
                }
                it("custom without body") {
                    let method = HttpMethod.custom("custom", false)
                    expect(method.hasBody()).to(equal(false))
                }
            }
        }
    }

}

