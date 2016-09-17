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
                        queryParameters: ["name": "Paul"],
                        pathParameters: [:])
                expect(url).to(equal("http://example.com/api/someRequest?name=Paul"))
            }

            it("can build base url with 1 query param") {
                let url = builder.buildUrlString("https://example.com",
                        path: nil,
                        queryParameters: ["name": "Paul"],
                        pathParameters: [:])
                expect(url).to(equal("https://example.com?name=Paul"))
            }

            it("can build url with 2 query param") {
                let url = builder.buildUrlString("http://example.com/api",
                        path: "/someRequest",
                        queryParameters: ["name": "Paul", "age": "24"],
                        pathParameters: [:])
                expect(url).to(equal("http://example.com/api/someRequest?age=24&name=Paul"))
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
                        queryParameters: ["name": "paul k"],
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
                        queryParameters: ["param": "!\"#$%&'()*+,-./"],
                        pathParameters: [:])
                expect(url).to(equal("http://example.com/api?param=%21%22%23%24%25%26%27%28%29%2A%2B%2C-./"))
            }
        }

        describe("url builder") {
            let builder = ParamsBuilder()
            
            it("can build url encoded string with no field parameters") {
                let encodedString = builder.stringFromFieldParameters([:])
                expect(encodedString).to(equal(""))
            }

            it("can build url encoded string with 1 field parameter") {
                let encodedString = builder.stringFromFieldParameters(["username": FieldParameter(value: "paul_k")])
                expect(encodedString).to(equal("username=paul_k"))
            }

            it("can build url encoded string with 2 field parameters") {
                let encodedString = builder.stringFromFieldParameters(["username": FieldParameter(value: "paul_k"),
                                                                       "password": FieldParameter(value: "pa  word")])
                expect(encodedString).to(equal("password=pa  word&username=paul_k"))
            }

            it("can build url encoded string with 1 encoded field parameter") {
                let encodedString = builder.stringFromFieldParameters(["password": FieldParameter(value: "pa  word", encoded: true)])
                expect(encodedString).to(equal("password=pa%20%20word"))
            }

            it("can build url encoded string with 2 mixed field parameters") {
                let encodedString = builder.stringFromFieldParameters(["username": FieldParameter(value: "paul_k"),
                                                                       "password": FieldParameter(value: "pa  word", encoded: true)])
                expect(encodedString).to(equal("password=pa%20%20word&username=paul_k"))
            }
        }

    }

}