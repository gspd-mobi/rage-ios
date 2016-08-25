import Foundation

public class Rage {

    private init() {
        // No operations.
    }

    public class func builderWithBaseUrl(baseUrl: String) -> Builder {
        return Builder(baseUrl: baseUrl)
    }

    public final class Builder {

        var baseUrl: String

        var contentType = ContentType.UrlEncoded

        var logLevel: LogLevel = .None
        var timeoutMillis: Int = 60 * 1000
        var headers = [String: String]()

        var authenticator: Authenticator?

        private init(baseUrl: String) {
            self.baseUrl = baseUrl
        }

        public func withContentType(contentType: ContentType) -> Builder {
            self.contentType = contentType
            return self
        }

        public func withLogLevel(logLevel: LogLevel) -> Builder {
            self.logLevel = logLevel
            return self
        }

        public func withTimeoutMillis(timeoutMillis: Int) -> Builder {
            self.timeoutMillis = timeoutMillis
            return self
        }

        public func withHeader(key: String, _ value: String) -> Builder {
            headers[key] = value
            return self
        }

        public func withHeaderDictionary(dictionary: [String:String]) -> Builder {
            dictionary.forEach {
                (key, value) in
                headers[key] = value
            }
            return self
        }

        public func withAuthenticator(authenticator: Authenticator?) -> Builder {
            self.authenticator = authenticator
            return self
        }

        public func build() -> RageClient {
            let config = RageClientDefaultConfiguration(baseUrl: baseUrl)
            config.contentType = contentType
            config.headers = headers
            config.logLevel = logLevel
            config.timeoutMillis = timeoutMillis
            config.authenticator = authenticator
            return RageClient(defaultConfiguration: config)
        }

    }

}
