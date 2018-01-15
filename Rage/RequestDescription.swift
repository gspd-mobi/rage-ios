import Foundation

open class RequestDescription {

    var httpMethod: HttpMethod
    var baseUrl: String?
    var path: String?
    var headers: [String: String] = [:]
    var contentType: ContentType

    var errorHandlers: [ErrorHandler] = []
    var authenticator: Authenticator?

    var timeoutMillis: Int = 60 * 1000

    var sessionProvider: SessionProvider = SessionProvider()

    init(defaultConfiguration: RageClientConfiguration,
         httpMethod: HttpMethod,
         path: String?) {
        self.httpMethod = httpMethod
        self.baseUrl = defaultConfiguration.baseUrl
        self.path = path
        for (key, value) in defaultConfiguration.headers {
            self.headers[key] = value
        }
        self.contentType = defaultConfiguration.contentType
        self.sessionProvider = defaultConfiguration.sessionProvider
    }

}
