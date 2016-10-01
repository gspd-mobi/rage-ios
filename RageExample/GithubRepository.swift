import Foundation
import ObjectMapper

class GithubRepository: Mappable {

    var repositoryId: Int?

    var name: String?
    var fullName: String?
    var url: String?

    var stars: Int?

    init() {
        // No operations.
    }

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        repositoryId <- map["id"]
        name <- map["name"]
        fullName <- map["full_name"]
        url <- map["url"]
        stars <- map["stargazers_count"]
    }

}
