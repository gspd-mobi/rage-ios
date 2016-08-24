import Foundation

public class RageClient {

    var baseUrl: String
    var logLevel: LogLevel
    var timeoutMillis: Int
    var logger: Logger
    var headers: [String:String]
    var contentType: ContentType

    init(baseUrl: String, contentType: ContentType, logLevel: LogLevel,
         timeoutMillis: Int, headers: [String:String]) {
        self.baseUrl = baseUrl
        self.contentType = contentType
        self.timeoutMillis = timeoutMillis
        self.logLevel = logLevel
        self.logger = Logger(logLevel: logLevel)
        self.headers = headers
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
        options.timeoutMillis = timeoutMillis

        let requestDescription = RequestDescription(httpMethod: httpMethod,
                baseUrl: baseUrl,
                contentType: contentType,
                path: path,
                headers: headers)
        return RageRequest(requestDescription: requestDescription,
                options: options,
                logger: logger)
    }

}
