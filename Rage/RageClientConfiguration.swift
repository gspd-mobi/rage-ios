import Foundation

public class RageClientConfiguration {
    var baseUrl: String
    var timeoutMillis: Int = 60 * 1000
    var headers = [String: String]()
    var contentType = ContentType.Json
    var authenticator: Authenticator?

    var plugins = [RagePlugin]()

    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
}
