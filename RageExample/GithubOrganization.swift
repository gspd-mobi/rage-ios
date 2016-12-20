import Foundation
import ObjectMapper

class GithubOrganization: Mappable {

    var organizationId: Int?

    var name: String?
    var location: String?
    var blog: String?

    init() {
        // No operations.
    }

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        organizationId <- map["id"]
        name <- map["name"]
        location <- map["location"]
        blog <- map["blog"]
    }

}
