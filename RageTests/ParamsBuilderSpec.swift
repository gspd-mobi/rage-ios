import Foundation
import Quick
import Nimble

class ParamsBuilderSpec: QuickSpec {

    override func spec() {
        describe("url builder") {
            let builder = URLBuilder()
            it("can build base url") {
                let url = builder.buildUrlString("http://example.com",
                        path: nil,
                        queryParameters: [:],
                        pathParameters: [:])
                expect(url).to(equal("http://example.com"))
            }

            it("can build url with method") {
                let url = builder.buildUrlString("http://example.com/api",
                        path: "/someRequest",
                        queryParameters: [:],
                        pathParameters: [:])
                expect(url).to(equal("http://example.com/api/someRequest"))
            }

            it("can build url with 1 query param") {
                let url = builder.buildUrlString("http://example.com/api",
                        path: "/someRequest",
                        queryParameters: ["name": SingleParameter(value: "Paul")],
                        pathParameters: [:])
                expect(url).to(equal("http://example.com/api/someRequest?name=Paul"))
            }

            it("can build url with 1 query param without value") {
                let url = builder.buildUrlString("http://example.com/api",
                                                 path: "/someRequest",
                                                 queryParameters: ["name": SingleParameter(value: nil)],
                                                 pathParameters: [:])
                expect(url).to(equal("http://example.com/api/someRequest?name"))
            }

            describe("can build url with 1 query param which is array") {
                let array = ["Alice", "Bob", "Charlie"]
                it("comma separated") {
                    let arrayParameter = ArrayParameter(values: array,
                                                        stringMode: ArrayParameter.StringMode.commaSeparated)
                    let url = builder.buildUrlString("http://example.com/api",
                                                     path: "/someRequest",
                                                     queryParameters: ["names": arrayParameter],
                                                     pathParameters: [:])
                    expect(url).to(equal("http://example.com/api/someRequest?names=Alice,Bob,Charlie"))
                }
                it("repeat key") {
                    let arrayParameter = ArrayParameter(values: array,
                                                        stringMode: ArrayParameter.StringMode.repeatKey)
                    let url = builder.buildUrlString("http://example.com/api",
                                                     path: "/someRequest",
                                                     queryParameters: ["names": arrayParameter],
                                                     pathParameters: [:])
                    expect(url).to(equal("http://example.com/api/someRequest?names=Alice&names=Bob&names=Charlie"))
                }

                it("repeat key brackets") {
                    let arrayParameter = ArrayParameter(values: array,
                                                        stringMode: ArrayParameter.StringMode.repeatKeyBrackets)
                    let url = builder.buildUrlString("http://example.com/api",
                                                     path: "/someRequest",
                                                     queryParameters: ["names": arrayParameter],
                                                     pathParameters: [:])
                    expect(url)
                        .to(equal("http://example.com/api/someRequest?names[]=Alice&names[]=Bob&names[]=Charlie"))
                }
                it("empty array") {
                    let arrayParameter = ArrayParameter(values: [],
                                                        stringMode: ArrayParameter.StringMode.repeatKeyBrackets)
                    let url = builder.buildUrlString("http://example.com/api",
                                                     path: "/someRequest",
                                                     queryParameters: ["names": arrayParameter],
                                                     pathParameters: [:])
                    expect(url)
                        .to(equal("http://example.com/api/someRequest"))
                }
            }

            it("can build base url with 1 query param") {
                let url = builder.buildUrlString("https://example.com",
                        path: nil,
                        queryParameters: ["name": SingleParameter(value: "Paul")],
                        pathParameters: [:])
                expect(url).to(equal("https://example.com?name=Paul"))
            }

            it("can build url with 2 query param") {
                let url = builder.buildUrlString("http://example.com/api",
                        path: "/someRequest",
                        queryParameters: ["name": SingleParameter(value: "Paul"),
                                          "age": SingleParameter(value: "24")],
                        pathParameters: [:])
                expect(["http://example.com/api/someRequest?name=Paul&age=24",
                        "http://example.com/api/someRequest?age=24&name=Paul"]).to(contain(url))
            }

            it("can build url with 2 query param with different value") {
                let url = builder.buildUrlString("http://example.com/api",
                                                 path: "/someRequest",
                                                 queryParameters: ["name": SingleParameter(value: "Paul"),
                                                                   "age": SingleParameter(value: nil)],
                                                 pathParameters: [:])
                expect(["http://example.com/api/someRequest?name=Paul&age",
                        "http://example.com/api/someRequest?age&name=Paul"]).to(contain(url))
            }

            it("can build url with 1 path param") {
                let url = builder.buildUrlString("http://example.com/api",
                        path: "/user/{userId}",
                        queryParameters: [:],
                        pathParameters: ["userId": "5"])
                expect(url).to(equal("http://example.com/api/user/5"))
            }

            it("can build url with 2 path param") {
                let url = builder.buildUrlString("http://example.com/api",
                        path: "/org/{org}/user/{userId}",
                        queryParameters: [:],
                        pathParameters: ["userId": "5", "org": "orgname"])
                expect(url).to(equal("http://example.com/api/org/orgname/user/5"))
            }

            it("can build url with encoded query param") {
                let url = builder.buildUrlString("http://example.com/api",
                        path: "/user",
                        queryParameters: ["name": SingleParameter(value: "paul k")],
                        pathParameters: [:])
                expect(url).to(equal("http://example.com/api/user?name=paul%20k"))
            }

            it("can build url with encoded path param") {
                let url = builder.buildUrlString("http://example.com/api",
                        path: "/user/{name}",
                        queryParameters: [:],
                        pathParameters: ["name": "paul k"])
                expect(url).to(equal("http://example.com/api/user/paul%20k"))
            }

            it("can build url with long encoded query param") {
                let url = builder.buildUrlString("http://example.com/api",
                        path: nil,
                        queryParameters: ["param": SingleParameter(value: "!\"#$%&'()*+,-./")],
                        pathParameters: [:])
                let exp = "http://example.com/api?param=%21%22%23%24%25%26%27%28%29%2A%2B%2C-./"
                expect(url).to(equal(exp))
            }

            it("can build url if question mark is already in url") {
                let url = builder.buildUrlString("http://example.com/api",
                                                 path: "/user?user=unknown",
                                                 queryParameters: ["param": SingleParameter(value: "value")],
                                                 pathParameters: [:])
                expect(url).to(equal("http://example.com/api/user?user=unknown&param=value"))
            }
        }

        describe("url builder") {
            let builder = ParamsBuilder()

            it("can build url encoded string with no field parameters") {
                let encodedString = builder.stringFromFieldParameters([:])
                expect(encodedString).to(equal(""))
            }

            it("can build url encoded string with 1 field parameter") {
                let encodedString = builder.stringFromFieldParameters(
                        ["username": SingleParameter(value: "paul_k")])
                print("encoded string here \(encodedString)")
                expect(encodedString).to(equal("username=paul_k"))
            }

            it("can build url encoded string with 2 field parameters") {
                let encodedString = builder.stringFromFieldParameters(
                        ["username": SingleParameter(value: "paul_k"),
                         "password": SingleParameter(value: "pa  word")])
                expect(["username=paul_k&password=pa%20%20word",
                        "password=pa%20%20word&username=paul_k"]).to(contain(encodedString))
            }

            it("can build url encoded string with 1 encoded field parameter") {
                let encodedString = builder.stringFromFieldParameters(
                        ["password": SingleParameter(value: "pa  word", encoded: true)])
                expect(encodedString).to(equal("password=pa%20%20word"))
            }

            it("can build url encoded string with 2 mixed field parameters") {
                let encodedString = builder.stringFromFieldParameters(
                        ["username": SingleParameter(value: "paul_k"),
                         "password": SingleParameter(value: "pa  word", encoded: true)])
                expect(["username=paul_k&password=pa%20%20word",
                        "password=pa%20%20word&username=paul_k"]).to(contain(encodedString))
            }
        }

    }

}
