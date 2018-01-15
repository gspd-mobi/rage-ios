import Foundation

open class RageClientConfiguration {

    var baseUrl: String?
    var headers: [String: String] = [:]
    var contentType = ContentType.json
    var authenticator: Authenticator?

    var plugins: [RagePlugin] = []
    var errorsHandlersClosure: () -> [ErrorHandler] = {
        []
    }
    var sessionProvider: SessionProvider = SessionProvider()

    init(baseUrl: String?) {
        self.baseUrl = baseUrl
    }

}
