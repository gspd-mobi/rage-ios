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

        init(baseUrl: String) {
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

        public func withHeaderDictionary(dictionary: [String:String?]) -> Builder {
            dictionary.forEach {
                (key, value) in
                if let safeValue = value {
                    headers[key] = safeValue
                } else {
                    headers.removeValueForKey(key)
                }
            }
            return self
        }

        public func build() -> RageClient {
            return RageClient(baseUrl: baseUrl,
                    contentType: self.contentType,
                    logLevel: self.logLevel,
                    timeoutMillis: self.timeoutMillis,
                    headers: self.headers)
        }

    }

}

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

public class RequestDescription {
    var httpMethod: HttpMethod
    var baseUrl: String
    var path: String?
    var headers: [String:String]
    var contentType: ContentType

    init(httpMethod: HttpMethod, baseUrl: String, contentType: ContentType,
         path: String?, headers: [String:String]) {
        self.httpMethod = httpMethod
        self.baseUrl = baseUrl
        self.path = path
        self.headers = headers
        self.contentType = contentType
    }
}

public class RequestOptions {
    var timeoutMillis: Int = 60 * 1000
}

public class RageRequest {

    let emptyResponseErrorMessage = "Empty response from server"
    let jsonParsingErrorMessage = "Couldn't parse object from JSON"
    let wrongUrlErrorMessage = "Wrong url provided for request"
    let wrongHttpMethodForBodyErrorMessage = "Can't add body to request with such HttpMethod"

    var httpMethod: HttpMethod
    var baseUrl: String
    var path: String?
    var queryParameters = [String: String]()
    var pathParameters = [String: String]()
    var fieldParameters = [String: String]()
    var headers: [String:String]
    var contentType: ContentType
    var body: NSData?

    var timeoutMillis: Int
    var logger: Logger

    init(requestDescription: RequestDescription,
         options: RequestOptions,
         logger: Logger) {
        self.httpMethod = requestDescription.httpMethod
        self.baseUrl = requestDescription.baseUrl
        self.path = requestDescription.path
        self.headers = requestDescription.headers
        self.contentType = requestDescription.contentType
        self.timeoutMillis = options.timeoutMillis
        self.logger = logger
    }

    // MARK: Parameters

    public func query<T>(key: String, _ value: T?) -> RageRequest {
        if let safeValue = value {
            queryParameters[key] = String(safeValue)
        }
        return self
    }

    public func queryDictionary<T>(dictionary: [String:T?]) -> RageRequest {
        dictionary.forEach {
            (key, value) in
            if let safeValue = value {
                queryParameters[key] = String(safeValue)
            }
        }
        return self
    }

    public func path<T>(key: String, _ value: T) -> RageRequest {
        pathParameters[key] = String(value)
        return self
    }

    public func field<T>(key: String, _ value: T) -> RageRequest {
        fieldParameters[key] = String(value)
        return self
    }

    public func fieldDictionary<T>(dictionary: [String:T]) -> RageRequest {
        dictionary.forEach {
            (key, value) in
            fieldParameters[key] = String(value)
        }
        return self
    }

    public func bodyData(value: NSData) -> RageRequest {
        if !httpMethod.hasBody() {
            preconditionFailure(self.wrongHttpMethodForBodyErrorMessage)
        }
        body = value
        return self
    }

    public func bodyString(value: String) -> RageRequest {
        if !httpMethod.hasBody() {
            preconditionFailure(self.wrongHttpMethodForBodyErrorMessage)
        }
        body = value.dataUsingEncoding(NSUTF8StringEncoding)
        return self
    }

    public func header(key: String, _ value: String?) -> RageRequest {
        guard let safeValue = value else {
            headers.removeValueForKey(key)
            return self
        }
        headers[key] = safeValue
        return self
    }

    public func headerDictionary(dictionary: [String:String?]) -> RageRequest {
        dictionary.forEach {
            (key, value) in
            if let safeValue = value {
                headers[key] = safeValue
            } else {
                headers.removeValueForKey(key)
            }
        }
        return self
    }

    public func contentType(contentType: ContentType) -> RageRequest {
        self.contentType = contentType
        return self
    }

    // MARK: Configurations

    public func withTimeoutMillis(timeoutMillis: Int) -> RageRequest {
        self.timeoutMillis = timeoutMillis
        return self
    }

    // MARK: Requests
    public func syncCall() -> (NSData?, NSURLResponse?, NSError?) {
        let urlString = ParamsBuilder.buildUrlString(self.baseUrl,
                path: self.path ?? "",
                queryParameters: self.queryParameters,
                pathParameters: self.pathParameters)
        logger.logRequestUrl(httpMethod, url: urlString)

        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let timeoutSeconds = Double(timeoutMillis) / 1000.0
        configuration.timeoutIntervalForRequest = timeoutSeconds
        configuration.timeoutIntervalForResource = timeoutSeconds

        let defaultSession = NSURLSession(configuration: configuration)
        let optionalUrl = NSURL(string: urlString)
        guard let url = optionalUrl else {
            preconditionFailure(self.wrongUrlErrorMessage)
        }

        logger.logContentType(contentType)
        logger.logHeaders(headers)

        if body == nil {
            body = ParamsBuilder.buildUrlEncodedString(fieldParameters)
            .dataUsingEncoding(NSUTF8StringEncoding)
        }

        if httpMethod.hasBody() {
            logger.logBody(body)
        }
        let (data, response, error) = defaultSession.synchronousDataTaskWithURL(httpMethod,
                url: url,
                contentType: contentType,
                headers: headers,
                bodyData: body)

        logger.logResponse(httpMethod, url: urlString, data: data, response: response)
        return (data, response, error)
    }

}
