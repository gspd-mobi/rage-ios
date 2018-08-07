import Foundation
import Quick
import Nimble
import Rage

class Person: Codable {

    let firstName: String?
    let lastName: String?
    let birthDay: Date?

    init(firstName: String? = nil,
         lastName: String? = nil,
         birthDay: Date? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.birthDay = birthDay
    }

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case birthDay = "birth_day"
    }

}

extension Person: Equatable {

    static func == (lhs: Person, rhs: Person) -> Bool {
        return
            lhs.firstName == rhs.firstName &&
                lhs.lastName == rhs.lastName &&
                lhs.birthDay == rhs.birthDay
    }

}

class RageCodableSpec: QuickSpec {

    override func spec() {
        describe("data parsing") {

            it("parse json object data to codable") {
                let jsonObjectString = """
                    {
                        "first_name": "Barbara",
                        "last_name": "Sanders"
                    }
                """
                let jsonObjectData = jsonObjectString.data(using: .utf8)!
                let jsonDecoder = JSONDecoder()
                let person = Person(firstName: "Barbara", lastName: "Sanders")
                let parsedPerson: Person? = jsonObjectData.parseJson(decoder: jsonDecoder)

                expect(parsedPerson).to(equal(person))
            }

            it("parse invalid json data to codable") {
                let jsonObjectString = """
                    {
                        first_name:  "Fabrizio"
                        "last_name": "Verdaasdonk"
                    }
                """
                let jsonObjectData = jsonObjectString.data(using: .utf8)!
                let jsonDecoder = JSONDecoder()
                let parsedPerson: Person? = jsonObjectData.parseJson(decoder: jsonDecoder)

                expect(parsedPerson).to(beNil())
            }

            it("parse invalid json array data to codable") {
                let jsonArrayString =  """
                [
                    {
                        first_name: "Laurenz"
                        "last_name": "Wenzel"
                    },
                    {
                        "first_name": "Hudson";
                        last_name: "Roy"
                    }
                ]
                """

                let jsonArrayData = jsonArrayString.data(using: .utf8)!
                let jsonDecoder = JSONDecoder()
                let parsedPersons: [Person]? = jsonArrayData.parseJsonArray(decoder: jsonDecoder)

                expect(parsedPersons).to(beNil())
            }

            it("parse json array data to codable") {
                let jsonArrayString = """
                [
                    {
                        "first_name": "Noah",
                        "last_name": "Ginnish"
                    },
                    {
                        "first_name": "Megan",
                        "last_name": "Claire"
                    }
                ]
                """

                let jsonArrayData = jsonArrayString.data(using: .utf8)!
                let jsonDecoder = JSONDecoder()
                let persons = [
                    Person(firstName: "Noah", lastName: "Ginnish"),
                    Person(firstName: "Megan", lastName: "Claire")
                ]
                let parsedPersons: [Person] = jsonArrayData.parseJsonArray(decoder: jsonDecoder)!

                expect(parsedPersons).to(equal(persons))
            }

            it("person json object data with date") {
                let jsonObjectString = """
                    {
                        "first_name": "Eva",
                        "last_name": "Lorenzo",
                        "birth_day": "18.08.2017"
                    }
                """
                let jsonObjectData = jsonObjectString.data(using: .utf8)!
                let jsonDecoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.YYYY"
                jsonDecoder.dateDecodingStrategy = .formatted(formatter)
                let date = formatter.date(from: "18.08.2017")!
                let person = Person(firstName: "Eva", lastName: "Lorenzo", birthDay: date)
                let parsedPerson: Person = jsonObjectData.parseJson(decoder: jsonDecoder)!

                expect(parsedPerson).to(equal(person))
            }

            it("parse person json object with invalid data") {
                let jsonObjectString = """
                    {
                        "first_name": "Tuba",
                        "last_name": "van Hagen",
                        "birth_day": "18.082017"
                    }
                """
                let jsonObjectData = jsonObjectString.data(using: .utf8)!
                let jsonDecoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.YYYY"
                jsonDecoder.dateDecodingStrategy = .formatted(formatter)
                let parsedPerson: Person? = jsonObjectData.parseJson(decoder: jsonDecoder)

                expect(parsedPerson).to(beNil())
            }

            it("parse json array with invalid date") {
                let jsonArrayString =  """
                [
                    {
                        "first_name": "Caetano",
                        "last_name": "Dias",
                        "birth_day": "1808.2017"
                    },
                    {
                        "first_name": "Michael",
                        "last_name": "Singh",
                        "birth_day": "19082017"
                    }
                ]
                """
                let jsonArrayData = jsonArrayString.data(using: .utf8)!
                let jsonDecoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.YYYY"
                let parsedPersons: [Person]? = jsonArrayData.parseJson(decoder: jsonDecoder)

                expect(parsedPersons).to(beNil())
            }

            it("person json array with date") {
                let jsonArrayString =  """
                [
                    {
                        "first_name": "Marc",
                        "last_name": "Austin",
                        "birth_day": "18.08.2017"
                    },
                    {
                        "first_name": "Amparo",
                        "last_name": "Parra",
                        "birth_day": "19.08.2017"
                    }
                ]
                """
                let jsonArrayData = jsonArrayString.data(using: .utf8)!
                let jsonDecoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.YYYY"
                jsonDecoder.dateDecodingStrategy = .formatted(formatter)
                let firstDate = formatter.date(from: "18.08.2017")
                let secondDate = formatter.date(from: "19.08.2017")
                let persons = [
                    Person(firstName: "Marc", lastName: "Austin", birthDay: firstDate),
                    Person(firstName: "Amparo", lastName: "Parra", birthDay: secondDate)
                ]
                let parsedPersons: [Person] = jsonArrayData.parseJsonArray(decoder: jsonDecoder)!

                expect(parsedPersons).to(equal(persons))
            }
        }

        describe("body rage request") {

            it("codable at BodyRageRequest body json") {
                let person = Person(firstName: "Jennifer", lastName: "Jenkins")
                let personString = try! person.toJSONString()
                let request = RageRequest(httpMethod: .post, baseUrl: "http://example.com")
                let bodyRageRequest = BodyRageRequest(from: request)
                _ = bodyRageRequest.bodyJson(person)
                let body = bodyRageRequest.rawRequest().httpBody!
                let bodyString = String(data: body, encoding: .utf8)!

                expect(bodyString).to(equal(personString))
            }

            it("codable array at BodyRageRequest body json") {
                let persons = [
                    Person(firstName: "Kimberly", lastName: "Stephens"),
                    Person(firstName: "Matilda", lastName: "Hunta")
                ]
                let personsString = try! persons.toJSONString()
                let request = RageRequest(httpMethod: .post, baseUrl: "http://example.com")
                let bodyRageRequest = BodyRageRequest(from: request)
                _ = bodyRageRequest.bodyJson(persons)
                let body = bodyRageRequest.rawRequest().httpBody!
                let bodyString = String(data: body, encoding: .utf8)!

                expect(bodyString).to(equal(personsString))
            }
        }

        describe("rage request stubs") {
            it("rage request codable stub") {
                let person = Person(firstName: "Kate", lastName: "Robinson")
                let personString = try! person.toJSONString()
                let request = RageRequest(httpMethod: .get, baseUrl: "http://example.com")
                _ = request.stub(person, mode: .immediate)
                let result  = request.execute().value?.data
                let resultString = String(data: result!, encoding: .utf8)!

                expect(resultString).to(equal(personString))
            }

            it("rage request codable array stub") {
                let persons = [
                    Person(firstName: "Debra", lastName: "Gilbert"),
                    Person(firstName: "John", lastName: "Harris")
                ]
                let personsString = try! persons.toJSONString()
                let request = RageRequest(httpMethod: .get, baseUrl: "http://example.com")
                _ = request.stub(persons, mode: .immediate)
                let result = request.execute().value?.data
                let resultString = String(data: result!, encoding: .utf8)!

                expect(resultString).to(equal(personsString))
            }
        }
    }

}
