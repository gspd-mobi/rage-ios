import Foundation
import Result

public class RageRequest: Call {

    let jsonParsingErrorMessage = "Couldn't parse object from JSON"
    let wrongUrlErrorMessage = "Wrong url provided for request"
    let wrongHttpMethodForBodyErrorMessage = "Can't add body to request with such HttpMethod"

    var httpMethod: HttpMethod
    var baseUrl: String
    var methodPath: String?
    var queryParameters: [String:String] = [:]
    var pathParameters: [String:String] = [:]
    var headers: [String:String] = [:]

    var errorHandlers: [ErrorHandler] = []

    var authenticator: Authenticator?
    var needAuth = false

    var timeoutMillis: Int = 60 * 1000
    var plugins: [RagePlugin]?

    var stubData: StubData?

    init(httpMethod: HttpMethod, baseUrl: String) {
        self.httpMethod = httpMethod
        self.baseUrl = baseUrl
    }

    init(requestDescription: RequestDescription,
         plugins: [RagePlugin]) {
        self.httpMethod = requestDescription.httpMethod
        self.baseUrl = requestDescription.baseUrl
        self.methodPath = requestDescription.path
        self.headers = requestDescription.headers
        self.headers["Content-Type"] = requestDescription.contentType.stringValue()

        self.errorHandlers = requestDescription.errorHandlers
        self.authenticator = requestDescription.authenticator

        self.timeoutMillis = requestDescription.timeoutMillis
        self.plugins = plugins
    }

    // MARK: Parameters

    public func url(url: String) -> RageRequest {
        self.baseUrl = url
        return self
    }

    public func query<T>(key: String, _ value: T?) -> RageRequest {
        guard let safeValue = value else {
            queryParameters.removeValueForKey(key)
            return self
        }
        queryParameters[key] = String(safeValue)
        return self
    }

    public func queryDictionary<T>(dictionary: [String:T?]) -> RageRequest {
        for (key, value) in dictionary {
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

    public func header(key: String, _ value: String?) -> RageRequest {
        guard let safeValue = value else {
            headers.removeValueForKey(key)
            return self
        }
        headers[key] = safeValue
        return self
    }

    public func headerDictionary(dictionary: [String:String?]) -> RageRequest {
        for (key, value) in dictionary {
            if let safeValue = value {
                headers[key] = safeValue
            } else {
                headers.removeValueForKey(key)
            }
        }
        return self
    }

    public func contentType(contentType: ContentType) -> RageRequest {
        self.headers["Content-Type"] = contentType.stringValue()
        return self
    }

    public func authorized(authenticator: Authenticator) -> RageRequest {
        self.authenticator = authenticator
        return authorized()
    }

    public func authorized(authErrorHandling: Bool = true) -> RageRequest {
        if let safeAuthenticator = authenticator {
            self.needAuth = true
            //self.authErrorHandling = authErrorHandling
            return safeAuthenticator.authorizeRequest(self)
        } else {
            preconditionFailure("Can't create authorized request without Authenticator provided")
        }
    }

    public func stub(data: NSData, mode: StubMode = .immediate) -> RageRequest {
        self.stubData = StubData(data: data, mode: mode)
        return self
    }

    public func stub(string: String, mode: StubMode = .immediate) -> RageRequest {
        guard let data = string.dataUsingEncoding(NSUTF8StringEncoding) else {
            return self
        }
        return self.stub(data, mode: mode)
    }

    public func withErrorHandlers(handlers: [ErrorHandler]) -> RageRequest {
        self.errorHandlers = handlers
        return self
    }

    // MARK: Configurations

    public func withTimeoutMillis(timeoutMillis: Int) -> RageRequest {
        self.timeoutMillis = timeoutMillis
        return self
    }

    // MARK: Requests

    func createSession() -> NSURLSession {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let timeoutSeconds = Double(timeoutMillis) / 1000.0
        configuration.timeoutIntervalForRequest = timeoutSeconds
        configuration.timeoutIntervalForResource = timeoutSeconds

        return NSURLSession(configuration: configuration)
    }

    func createErrorFromResponse(rageResponse: RageResponse) -> RageError {
        if rageResponse.error == nil && rageResponse.data?.length ?? 0 == 0 {
            return RageError(type: .EmptyNetworkResponse)
        }
        if rageResponse.error == nil {
            return RageError(type: .Http, rageResponse: rageResponse)
        }

        return RageError(type: .Raw, rageResponse: rageResponse)
    }

    func url() -> String {
        return ParamsBuilder.buildUrlString(self.baseUrl,
                path: self.methodPath ?? "",
                queryParameters: self.queryParameters,
                pathParameters: self.pathParameters)
    }

    // MARK: Complex request abstractions

    public func withBody() -> BodyRageRequest {
        return BodyRageRequest(from: self)
    }

    public func multipart() -> MultipartRageRequest {
        return MultipartRageRequest(from: self)
    }

    public func formUrlEncoded() -> FormUrlEncodedRequest {
        return FormUrlEncodedRequest(from: self)
    }

    // MARK: Executing

    public func execute() -> Result<RageResponse, RageError> {
        if let plugins = plugins {
            for plugin in plugins {
                plugin.willSendRequest(self)
            }
        }

        let request = rawRequest()

        if let plugins = plugins {
            for plugin in plugins {
                plugin.didSendRequest(self, rawRequest: request)
            }
        }

        if let s = getStubData() {
            let rageResponse = RageResponse(request: self, data: s, response: nil, error: nil)
            if let plugins = plugins {
                for plugin in plugins {
                    plugin.didReceiveResponse(rageResponse, rawRequest: request)
                }
            }
            return .Success(rageResponse)
        }

        let session = createSession()

        let (data, response, error) = session.syncTask(request)
        let rageResponse = RageResponse(request: self, data: data, response: response, error: error)

        if let plugins = plugins {
            for plugin in plugins {
                plugin.didReceiveResponse(rageResponse, rawRequest: request)
            }
        }

        if rageResponse.isSuccess() {
            return .Success(rageResponse)
        }
        let rageError = createErrorFromResponse(rageResponse)
        let result: Result<RageResponse, RageError> = .Failure(rageError)
        for handler in errorHandlers {
            if handler.enabled && handler.isError(rageError) {
                return handler.handleError(self, result: result)
            }
        }
        return result
    }

    public func enqueue(completion: Result<RageResponse, RageError> -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            let result = self.execute()

            dispatch_async(dispatch_get_main_queue(), {
                return result
            })
        })
    }

    public func rawRequest() -> NSURLRequest {
        let urlString = url()
        let optionalUrl = NSURL(string: urlString)
        guard let url = optionalUrl else {
            preconditionFailure(self.wrongUrlErrorMessage)
        }

        let request = NSMutableURLRequest(URL: url)
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.HTTPMethod = httpMethod.stringValue()
        return request
    }

    func isStubbed() -> Bool {
        guard let s = stubData else {
            return false
        }
        switch s.mode {
        case .never:
            return false
        default:
            return true
        }
    }

    private func getStubData() -> NSData? {
        guard let s = stubData else {
            return nil
        }
        switch s.mode {
        case .never:
            return nil
        case .immediate:
            return s.data
        case .delayed(let delayMillis):
            let seconds = Double(delayMillis) / 1000
            NSThread.sleepForTimeInterval(seconds)
            return s.data
        }
    }

}
