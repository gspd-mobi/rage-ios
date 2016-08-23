import Foundation
import ObjectMapper

class GithubUser: Mappable {

    var userId: Int?

    var login: String?
    var avatarUrl: String?
    var htmlUrl: String?

    var name: String?
    var email: String?
    var location: String?

    init() {
        // No operations.
    }

    required init?(_ map: Map) {

    }

    func mapping(map: Map) {
        userId <- map["id"]
        login <- map["login"]
        avatarUrl <- map["avatar_url"]
        htmlUrl <- map["html_url"]
        name <- map["name"]
        email <- map["email"]
        location <- map["location"]
    }

}
