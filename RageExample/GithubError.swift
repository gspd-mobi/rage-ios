import Foundation
import ObjectMapper

class GithubError: Mappable {

    var message: String?

    init() {
        // No operations.
    }

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        message <- map["message"]
    }

}
