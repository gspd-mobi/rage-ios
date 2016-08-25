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

public class RageClient {

    var defaultConfiguration: RageClientConfiguration

    init(defaultConfiguration: RageClientConfiguration) {
        self.defaultConfiguration = defaultConfiguration
    }

    public func get(path: String?) -> RageRequest {
        return createRequest(HttpMethod.GET, path: path)
    }

    public func post(path: String?) -> RageRequest {
        return createRequest(HttpMethod.POST, path: path)
    }

    public func put(path: String?) -> RageRequest {
        return createRequest(HttpMethod.PUT, path: path)
    }

    public func delete(path: String?) -> RageRequest {
        return createRequest(HttpMethod.DELETE, path: path)
    }

    public func head(path: String?) -> RageRequest {
        return createRequest(HttpMethod.HEAD, path: path)
    }

    public func patch(path: String?) -> RageRequest {
        return createRequest(HttpMethod.PATCH, path: path)
    }

    public func customMethod(method: String, path: String?) -> RageRequest {
        return createRequest(HttpMethod.CUSTOM(method), path: path)
    }

    private func createRequest(httpMethod: HttpMethod, path: String?) -> RageRequest {
        let options = RequestOptions()
        options.timeoutMillis = defaultConfiguration.timeoutMillis

        let requestDescription = RequestDescription(defaultConfiguration: defaultConfiguration,
                httpMethod: httpMethod,
                path: path)

        requestDescription.authenticator = self.defaultConfiguration.authenticator

        return RageRequest(requestDescription: requestDescription,
                options: options,
                plugins: defaultConfiguration.plugins
        )
    }

}
