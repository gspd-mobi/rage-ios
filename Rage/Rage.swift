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

    private func createRequest(httpMethod: HttpMethod, path: String?) -> RageRequest {
        return RageRequest(httpMethod: httpMethod, baseUrl: baseUrl, path: path, logger: logger)
    }

}

public class RageRequest {

    var httpMethod: HttpMethod
    var baseUrl: String
    var path: String?
    var queryParameters = [String: String]()
    var pathParameters = [String: String]()
    var headers = [String: String]()
    var body: Any?

    var logger: Logger

    init(httpMethod: HttpMethod, baseUrl: String, path: String?, logger: Logger) {
        self.httpMethod = httpMethod
        self.baseUrl = baseUrl
        self.path = path
        self.logger = logger
    }

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

    public func body<T>(value: T, dataTransferFormat: DataTransferFormat = .Json) -> RageRequest {
        body = value
        return self
    }

    public func header(key: String, _ value: String) -> RageRequest {
        headers[key] = value
        return self
    }

    public func requestJson<T:Mappable>() -> Observable<T> {
        return Observable<T>.create {
            subscriber in
            let (data, response, error) = self.syncCall()
            if let error = error {
                subscriber.onError(RageError(error.localizedDescription))
            } else {
                let parsedObject: T? = data?.parseJson()
                if let resultObject = parsedObject {
                    subscriber.onNext(resultObject)
                    subscriber.onCompleted()
                } else {
                    subscriber.onError(RageError("Couldn't parse object from JSON"))
                }
            }

            return NopDisposable.instance
        }
    }


    public func requestString() -> Observable<String> {
        return Observable<String>.create {
            subscriber in
            let (data, response, error) = self.syncCall()
            if let error = error {
                subscriber.onError(RageError(error.localizedDescription))
            } else {
                guard let data = data else {
                    subscriber.onError(RageError("Empty response"))
                    return NopDisposable.instance
                }

                let resultString = String(data: data, encoding: NSUTF8StringEncoding)!
                subscriber.onNext(resultString)
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
        if self.httpMethod == .GET {
            let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            let url = NSURL(string: urlString)

            logger.logHeaders(headers)
            let (data, response, error) = defaultSession.synchronousDataTaskWithURL(url!, headers: headers)

            logger.logResponse(httpMethod, url: urlString, data: data, response: response)
            return (data, response, error)
        } else {
            // todo
            return (nil, nil, nil)
        }
    }

}