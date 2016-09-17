import Foundation

public class RageClient {

    let defaultConfiguration: RageClientConfiguration

    init(defaultConfiguration: RageClientConfiguration) {
        self.defaultConfiguration = defaultConfiguration
    }

    public func get(path: String? = nil) -> RageRequest {
        return createRequest(HttpMethod.GET, path: path)
    }

    public func post(path: String? = nil) -> RageRequest {
        return createRequest(HttpMethod.POST, path: path)
    }

    public func put(path: String? = nil) -> RageRequest {
        return createRequest(HttpMethod.PUT, path: path)
    }

    public func delete(path: String? = nil) -> RageRequest {
        return createRequest(HttpMethod.DELETE, path: path)
    }

    public func head(path: String? = nil) -> RageRequest {
        return createRequest(HttpMethod.HEAD, path: path)
    }

    public func patch(path: String? = nil) -> RageRequest {
        return createRequest(HttpMethod.PATCH, path: path)
    }

    public func customMethod(method: String, path: String? = nil) -> RageRequest {
        return createRequest(HttpMethod.CUSTOM(method), path: path)
    }

    private func createRequest(httpMethod: HttpMethod, path: String?) -> RageRequest {
        let requestDescription = RequestDescription(defaultConfiguration: defaultConfiguration,
                httpMethod: httpMethod,
                path: path)

        requestDescription.authenticator = self.defaultConfiguration.authenticator
        requestDescription.timeoutMillis = self.defaultConfiguration.timeoutMillis
        requestDescription.errorHandlers = self.defaultConfiguration.errorsHandlersClosure()

        return RageRequest(requestDescription: requestDescription,
                plugins: defaultConfiguration.plugins)
    }

}
