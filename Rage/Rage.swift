import Foundation

open class Rage {

    fileprivate init() {
        // No operations.
    }

    open class func builderWithBaseUrl(_ baseUrl: String) -> Builder {
        return Builder(baseUrl: baseUrl)
    }

    public final class Builder {

        let config: RageClientConfiguration

        fileprivate init(baseUrl: String) {
            config = RageClientConfiguration(baseUrl: baseUrl)
        }

        public func withContentType(_ contentType: ContentType) -> Builder {
            config.contentType = contentType
            return self
        }

        public func withTimeoutMillis(_ timeoutMillis: Int) -> Builder {
            config.timeoutMillis = timeoutMillis
            return self
        }

        public func withHeader(_ key: String, _ value: String) -> Builder {
            config.headers[key] = value
            return self
        }

        public func withHeaderDictionary(_ dictionary: [String:String]) -> Builder {
            for (key, value) in dictionary {
                config.headers[key] = value
            }
            return self
        }

        public func withPlugin(_ plugin: RagePlugin) -> Builder {
            config.plugins.append(plugin)
            return self
        }

        public func withAuthenticator(_ authenticator: Authenticator?) -> Builder {
            config.authenticator = authenticator
            return self
        }

        public func withErrorsHandlersClosure(_ closure: @escaping () -> [ErrorHandler])
                -> Builder {
            config.errorsHandlersClosure = closure
            return self
        }

        public func build() -> RageClient {
            return RageClient(defaultConfiguration: config)
        }

    }

}
