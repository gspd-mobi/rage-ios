import Foundation

public class RageClientConfiguration {
    var baseUrl: String
    var timeoutMillis: Int = 60 * 1000
    var headers: [String:String] = [:]
    var contentType = ContentType.json
    var authenticator: Authenticator?

    var plugins: [RagePlugin] = []
    var errorsHandlersClosure: () -> [ErrorHandler] = {[]}

    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
}
