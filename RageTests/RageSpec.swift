import Foundation
import Quick
import Nimble

class RageSpec: QuickSpec {

    override func spec() {
        describe("rage") {

            it("can set base url") {
                let builder = Rage.builderWithBaseUrl("http://example.com")
                expect(builder.config.baseUrl).to(equal("http://example.com"))
            }

            let builder = Rage.builderWithBaseUrl("http://example.com")
            it("can set content type") {
                _ = builder.withContentType(ContentType.json)
                expect(builder.config.contentType).to(equal(ContentType.json))
            }

            it("can add default header") {
                _ = builder.withHeader("Authorization", "Bearer someoauthtokenstring")
                expect(builder.config.headers["Authorization"])
                    .to(equal("Bearer someoauthtokenstring"))
            }

            it("can add default headers with dictionary") {
                _ = builder.withHeaderDictionary([
                        "SomeOtherHeader": "someotherheadervalue"])
                expect(builder.config.headers["Authorization"])
                    .to(equal("Bearer someoauthtokenstring"))
                expect(builder.config.headers["SomeOtherHeader"])
                    .to(equal("someotherheadervalue"))
            }

            it("can add plugin") {
                let plugin = TestPlugin()
                _ = builder.withPlugin(plugin)
                expect(builder.config.plugins.count).to(equal(1))
            }

            it("can set authenticator") {
                let auth = TestAuthenticator()
                _ = builder.withAuthenticator(auth)
                expect(builder.config.authenticator).toNot(beNil())
            }

            it("can build client with config provided") {
                let client = builder.build()
                expect(client.defaultConfiguration) === builder.config
            }
        }
    }
}
