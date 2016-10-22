import Foundation

open class RageClient {

    let defaultConfiguration: RageClientConfiguration

    init(defaultConfiguration: RageClientConfiguration) {
        self.defaultConfiguration = defaultConfiguration
    }

    open func get(_ path: String? = nil) -> RageRequest {
        return createRequestWithHttpMethod(HttpMethod.get, path: path)
    }

    open func post(_ path: String? = nil) -> RageRequest {
        return createRequestWithHttpMethod(HttpMethod.post, path: path)
    }

    open func put(_ path: String? = nil) -> RageRequest {
        return createRequestWithHttpMethod(HttpMethod.put, path: path)
    }

    open func delete(_ path: String? = nil) -> RageRequest {
        return createRequestWithHttpMethod(HttpMethod.delete, path: path)
    }

    open func head(_ path: String? = nil) -> RageRequest {
        return createRequestWithHttpMethod(HttpMethod.head, path: path)
    }

    open func patch(_ path: String? = nil) -> RageRequest {
        return createRequestWithHttpMethod(HttpMethod.patch, path: path)
    }

    open func customMethod(_ method: String,
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
                           plugins: defaultConfiguration.plugins)
    }

}
