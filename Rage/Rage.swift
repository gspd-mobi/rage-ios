import Foundation
import RxSwift
import ObjectMapper

public class Rage {

    private init() {
        // No operations.
    }

    public class func builder() -> Builder {
        return Builder()
    }

    public final class Builder {

        var baseUrl: String?
        var logLevel: LogLevel = .None
        var timeoutMillis: Int = 60 * 1000

        public func withBaseUrl(url: String) -> Builder {
            self.baseUrl = url
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

        public func build() -> RageClient {
            guard let baseUrl = self.baseUrl else {
                preconditionFailure("Can't build client without baseUrl provided")
            }
            return RageClient(baseUrl: baseUrl,
                    logLevel: self.logLevel,
                    timeoutMillis: self.timeoutMillis)
        }

    }

}

public class RageClient {

    var baseUrl: String
    var logLevel: LogLevel
    var timeoutMillis: Int
    var logger: Logger

    init(baseUrl: String, logLevel: LogLevel, timeoutMillis: Int) {
        self.baseUrl = baseUrl
        self.timeoutMillis = timeoutMillis
        self.logLevel = logLevel
        self.logger = Logger(logLevel: logLevel)
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
        return RageRequest(httpMethod: httpMethod, baseUrl: baseUrl, path: path, timeoutMillis: timeoutMillis, logger: logger)
    }

}

public class RageRequest {

    private let emptyResponseErrorMessage = "Empty response from server"
    private let jsonParsingErrorMessage = "Couldn't parse object from JSON"
    private let wrongUrlErrorMessage = "Wrong url provided for request"

    var httpMethod: HttpMethod
    var baseUrl: String
    var path: String?
    var queryParameters = [String: String]()
    var pathParameters = [String: String]()
    var headers = [String: String]()
    var body: NSData?

    var timeoutMillis: Int
    var logger: Logger

    init(httpMethod: HttpMethod, baseUrl: String, path: String?, timeoutMillis: Int, logger: Logger) {
        self.httpMethod = httpMethod
        self.baseUrl = baseUrl
        self.path = path
        self.timeoutMillis = timeoutMillis
        self.logger = logger
    }

    // MARK: Parameters

    public func query<T>(key: String, _ value: T?) -> RageRequest {
        if let nonNullValue = value {
            queryParameters[key] = String(nonNullValue)
        }
        return self
    }

    public func path<T>(key: String, _ value: T) -> RageRequest {
        pathParameters[key] = String(value)
        return self
    }

    public func bodyData(value: NSData) -> RageRequest {
        body = value
        return self
    }

    public func bodyString(value: String) -> RageRequest {
        body = value.dataUsingEncoding(NSUTF8StringEncoding)
        return self
    }

    public func bodyJson(value: Mappable) -> RageRequest {
        guard let json = value.toJSONString() else {
            return self
        }
        return bodyString(json)
    }

    public func header(key: String, _ value: String) -> RageRequest {
        headers[key] = value
        return self
    }

    // MARK: Configurations

    public func withTimeoutMillis(timeoutMillis: Int) -> RageRequest {
        self.timeoutMillis = timeoutMillis
        return self
    }

    // MARK: Requests

    public func requestJson<T:Mappable>() -> Observable<T> {
        return Observable<T>.create {
            subscriber in
            let (data, _, error) = self.syncCall()
            if let error = error {
                subscriber.onError(RageError(error.localizedDescription))
            } else {
                let parsedObject: T? = data?.parseJson()
                if let resultObject = parsedObject {
                    subscriber.onNext(resultObject)
                    subscriber.onCompleted()
                } else {
                    subscriber.onError(RageError(self.jsonParsingErrorMessage))
                }
            }

            return NopDisposable.instance
        }
    }
    
    public func requestJson<T:Mappable>() -> Observable<[T]> {
        return Observable<[T]>.create {
            subscriber in
            let (data, _, error) = self.syncCall()
            if let error = error {
                subscriber.onError(RageError(error.localizedDescription))
            } else {
                let parsedObject: [T]? = data?.parseJsonArray()
                if let resultObject = parsedObject {
                    subscriber.onNext(resultObject)
                    subscriber.onCompleted()
                } else {
                    subscriber.onError(RageError(self.jsonParsingErrorMessage))
                }
            }
            
            return NopDisposable.instance
        }
    }

    public func requestString() -> Observable<String> {
        return Observable<String>.create {
            subscriber in
            let (data, _, error) = self.syncCall()
            if let error = error {
                subscriber.onError(RageError(error.localizedDescription))
            } else {
                guard let data = data else {
                    subscriber.onError(RageError(self.emptyResponseErrorMessage))
                    return NopDisposable.instance
                }

                let resultString = String(data: data, encoding: NSUTF8StringEncoding)!
                subscriber.onNext(resultString)
                subscriber.onCompleted()
            }

            return NopDisposable.instance
        }
    }

    public func requestData() -> Observable<NSData> {
        return Observable<NSData>.create {
            subscriber in
            let (data, _, error) = self.syncCall()
            if let error = error {
                subscriber.onError(RageError(error.localizedDescription))
            } else {
                guard let data = data else {
                    subscriber.onError(RageError(self.emptyResponseErrorMessage))
                    return NopDisposable.instance
                }

                subscriber.onNext(data)
                subscriber.onCompleted()
            }

            return NopDisposable.instance
        }
    }

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

        logger.logHeaders(headers)
        if httpMethod.hasBody() {
            logger.logBody(body)
        }
        let (data, response, error) = defaultSession.synchronousDataTaskWithURL(httpMethod, url: url, headers: headers, bodyData: body)

        logger.logResponse(httpMethod, url: urlString, data: data, response: response)
        return (data, response, error)
    }

}