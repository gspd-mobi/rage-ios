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
                builder.withContentType(ContentType.json)
                expect(builder.config.contentType).to(equal(ContentType.json))
            }

            it("can set timeout") {
                builder.withTimeoutMillis(1000)
                expect(builder.config.timeoutMillis).to(equal(1000))
            }

            it("can add default header") {
                builder.withHeader("Authorization", "Bearer someoauthtokenstring")
                expect(builder.config.headers["Authorization"]).to(equal("Bearer someoauthtokenstring"))
            }

            it("can add default headers with dictionary") {
                builder.withHeaderDictionary([
                        "SomeOtherHeader": "someotherheadervalue"])
                expect(builder.config.headers["Authorization"]).to(equal("Bearer someoauthtokenstring"))
                expect(builder.config.headers["SomeOtherHeader"]).to(equal("someotherheadervalue"))
            }

            it("can add plugin") {
                let plugin = TestPlugin()
                builder.withPlugin(plugin)
                expect(builder.config.plugins.count).to(equal(1))
            }

            it("can set authenticator") {
                let auth = TestAuthenticator()
                builder.withAuthenticator(auth)
                expect(builder.config.authenticator).toNot(beNil())
            }

            it("can set error handlers closure") {
                expect(builder.config.errorsHandlersClosure()).to(beEmpty())
                let testErrorHandler = TestErrorHandler()
                builder.withErrorsHandlersClosure {
                    [testErrorHandler]
                }
                expect(builder.config.errorsHandlersClosure().count).to(equal(1))
            }

            it("can build client with config provided") {
                let client = builder.build()
                expect(client.defaultConfiguration) === builder.config
            }
        }
    }
}
