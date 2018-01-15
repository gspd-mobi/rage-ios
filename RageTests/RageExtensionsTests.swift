import Foundation
import Quick
import Nimble

class RageExtensionsSpec: QuickSpec {

    override func spec() {
        describe("data") {
            it("pretty print can be done") {
                let prettyJson = """
                {
                  "someObject" : "someValue"
                }
                """
                let json = "{\"someObject\":\"someValue\"}"
                let data = json.utf8Data()!
                let prettyPrintedJson = data.prettyJsonString()
                expect(prettyPrintedJson).to(equal(prettyJson))
            }
            it("pretty print on wrong json should be nil") {
                let wrongJson = "{:}"
                let data = wrongJson.utf8Data()!
                let prettyPrintedJson = data.prettyJsonString()
                expect(prettyPrintedJson).to(beNil())
            }
            it("utf8 string can be created") {
                let str = "example"
                let data = str.utf8Data()
                let createdString = data?.utf8String()
                expect(createdString).to(equal(str))
            }
        }
        describe("string") {
            it("utf8 data can be created") {
                let str = "example"
                let data = str.data(using: .utf8)
                let createdData = str.utf8Data()
                expect(data).to(equal(createdData))
            }
        }
    }

}
