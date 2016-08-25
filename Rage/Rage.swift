import Foundation

public class Rage {

    private init() {
        // No operations.
    }

    public class func builderWithBaseUrl(baseUrl: String) -> Builder {
        return Builder(baseUrl: baseUrl)
    }

    public final class Builder {

        let config: RageClientConfiguration

        private init(baseUrl: String) {
            config = RageClientConfiguration(baseUrl: baseUrl)
        }

        public func withContentType(contentType: ContentType) -> Builder {
            config.contentType = contentType
            return self
        }

        public func withTimeoutMillis(timeoutMillis: Int) -> Builder {
            config.timeoutMillis = timeoutMillis
            return self
        }

        public func withHeader(key: String, _ value: String) -> Builder {
            config.headers[key] = value
            return self
        }

        public func withHeaderDictionary(dictionary: [String:String]) -> Builder {
            dictionary.forEach {
                (key, value) in
                config.headers[key] = value
            }
            return self
        }

        public func withPlugin(ragePlugin: RagePlugin) -> Builder {
            config.plugins.append(ragePlugin)
            return self
        }

        public func withAuthenticator(authenticator: Authenticator?) -> Builder {
            config.authenticator = authenticator
            return self
        }

        public func build() -> RageClient {
            return RageClient(defaultConfiguration: config)
        }

    }

}
