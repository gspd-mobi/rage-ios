import Foundation

open class RageClient {

    let defaultConfiguration: RageClientConfiguration
    let session: URLSession

    init(defaultConfiguration: RageClientConfiguration) {
        self.defaultConfiguration = defaultConfiguration

        let configuration = URLSessionConfiguration.default
        let timeoutSeconds = Double(defaultConfiguration.timeoutMillis) / 1000.0
        configuration.timeoutIntervalForRequest = timeoutSeconds
        configuration.timeoutIntervalForResource = timeoutSeconds

        self.session = URLSession(configuration: configuration)
    }

    public func get(_ path: String? = nil) -> RageRequest {
        return createRequestWithHttpMethod(HttpMethod.get, path: path)
    }

    public func post(_ path: String? = nil) -> RageRequest {
        return createRequestWithHttpMethod(HttpMethod.post, path: path)
    }

    public func put(_ path: String? = nil) -> RageRequest {
        return createRequestWithHttpMethod(HttpMethod.put, path: path)
    }

    public func delete(_ path: String? = nil) -> RageRequest {
        return createRequestWithHttpMethod(HttpMethod.delete, path: path)
    }

    public func head(_ path: String? = nil) -> RageRequest {
        return createRequestWithHttpMethod(HttpMethod.head, path: path)
    }

    public func patch(_ path: String? = nil) -> RageRequest {
        return createRequestWithHttpMethod(HttpMethod.patch, path: path)
    }

    public func customMethod(_ method: String,
                             path: String? = nil,
                             hasBody: Bool = false) -> RageRequest {
        return createRequestWithHttpMethod(HttpMethod.custom(method, hasBody), path: path)
    }

    func createRequestWithHttpMethod(_ httpMethod: HttpMethod, path: String?) -> RageRequest {
        let requestDescription: RequestDescription = {
            let requestDescription = RequestDescription(defaultConfiguration: defaultConfiguration,
                                                        httpMethod: httpMethod,
                                                        path: path)
            let config = self.defaultConfiguration
            requestDescription.authenticator = config.authenticator
            requestDescription.timeoutMillis = config.timeoutMillis
            requestDescription.errorHandlers = config.errorsHandlersClosure()
            return requestDescription
        }()

        return RageRequest(requestDescription: requestDescription,
                           session: session,
                           plugins: defaultConfiguration.plugins)
    }

}
