import Foundation

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
