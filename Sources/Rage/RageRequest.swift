import Foundation

open class RageRequest {

    public var httpMethod: HttpMethod
    var baseUrl: String?
    var methodPath: String?
    var queryParameters: [String: Parameter] = [:]
    var pathParameters: [String: String] = [:]
    var headers: [String: String] = [:]
    var isAuthorized: Bool = false

    var authenticator: Authenticator?
    var plugins: [RagePlugin] = []

    var stubData: StubData?

    public var session: URLSession

    public init(httpMethod: HttpMethod,
                baseUrl: String?) {
        self.httpMethod = httpMethod
        self.baseUrl = baseUrl
        self.session = SessionProvider().session
    }

    public init(requestDescription: RequestDescription) {
        self.httpMethod = requestDescription.httpMethod
        self.baseUrl = requestDescription.baseUrl
        self.methodPath = requestDescription.path
        self.headers = requestDescription.headers
        self.headers[ContentType.key] = requestDescription.contentType.stringValue()

        self.authenticator = requestDescription.authenticator

        self.plugins = requestDescription.plugins
        self.session = requestDescription.sessionProvider.session
    }

    open func execute() -> Result<RageResponse, RageError> {
        sendPluginsWillSendRequest()

        let request = rawRequest()

        sendPluginsDidSendRequest(request)

        if let stub = getStubData() {
            let rageResponse = RageResponse(request: self, data: stub, response: nil, error: nil)
            sendPluginsDidReceiveResponse(rageResponse, rawRequest: request)
            return .success(rageResponse)
        }

        var data: Data?
        var response: URLResponse?
        var error: NSError?

        let startDate = Date()

        let semaphore = DispatchSemaphore(value: 0)

        session.dataTask(with: request, completionHandler: {
            data = $0; response = $1; error = $2 as NSError?
            semaphore.signal()
        }) .resume()

        _ = semaphore.wait(timeout: DispatchTime.distantFuture)

        let requestDuration = Date().timeIntervalSince(startDate) * 1000

        let rageResponse = RageResponse(request: self,
                                        data: data,
                                        response: response,
                                        error: error,
                                        timeMillis: requestDuration)

        sendPluginsDidReceiveResponse(rageResponse, rawRequest: request)

        if rageResponse.isSuccess() {
            return .success(rageResponse)
        }
        let rageError = RageError(response: rageResponse)
        return .failure(rageError)
    }

    open func rawRequest() -> URLRequest {
        if isAuthorized {
            _ = authenticator?.authorizeRequest(self)
        }
        let url = URLBuilder().fromRequest(self)
        let request = NSMutableURLRequest(url: url)
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = httpMethod.stringValue()
        return request as URLRequest
    }

}

extension RageRequest {

    // MARK: Parameters

    open func url(_ url: String) -> Self {
        self.baseUrl = url
        return self
    }

    open func query<T>(_ key: String, _ value: T?, encoded: Bool = true) -> Self {
        let param: Parameter?
        if let safeValue = value {
            param = SingleParameter(value: String(describing: safeValue),
                                    encoded: encoded)
        } else {
            param = nil
        }
        queryParameters[key] = param
        return self
    }

    open func queryArray<T>(_ key: String,
                            _ values: [T],
                            stringMode: ArrayParameter.StringMode = .repeatKeyBrackets,
                            encoded: Bool = true) -> Self {
        queryParameters[key] = ArrayParameter(values: values.map { String(describing: $0) },
                                              stringMode: stringMode,
                                              encoded: encoded)
        return self
    }

    open func queryNoValue(_ key: String, encoded: Bool = true) -> Self {
        queryParameters[key] = SingleParameter(value: nil,
                                               encoded: encoded)
        return self
    }

    open func queryDictionary<T>(_ dictionary: [String: T?]) -> Self {
        for (key, value) in dictionary {
            _ = query(key, value)
        }
        return self
    }

    open func path<T>(_ key: String, _ value: T) -> Self {
        pathParameters[key] = String(describing: value)
        return self
    }

    open func header<T>(_ key: String, _ value: T?) -> Self {
        guard let safeValue = value else {
            headers.removeValue(forKey: key)
            return self
        }
        headers[key] = String(describing: safeValue)
        return self
    }

    open func headerDictionary<T>(_ dictionary: [String: T?]) -> Self {
        for (key, value) in dictionary {
            if let safeValue = value {
                headers[key] = String(describing: safeValue)
            } else {
                headers.removeValue(forKey: key)
            }
        }
        return self
    }

    open func contentType(_ contentType: ContentType) -> Self {
        self.headers[ContentType.key] = contentType.stringValue()
        return self
    }

    open func authorized(with authenticator: Authenticator) -> Self {
        self.authenticator = authenticator
        return authorized()
    }

    open func authorized(_ authorized: Bool = true) -> Self {
        self.isAuthorized = authorized
        return self
    }

    open func stub(_ data: Data, mode: StubMode = .immediate) -> Self {
        self.stubData = StubData(data: data, mode: mode)
        return self
    }

    open func stub(_ string: String, mode: StubMode = .immediate) -> Self {
        guard let data = string.utf8Data() else {
            return self
        }
        return self.stub(data, mode: mode)
    }

}

extension RageRequest {

    // MARK: Executing

    open func executeString() -> Result<String, RageError> {
        let result = self.execute()

        switch result {
        case .success(let response):
            guard let data = response.data else {
                return .failure(RageError(type: RageErrorType.emptyNetworkResponse))
            }

            let resultString = String(data: data, encoding: String.Encoding.utf8)!
            return .success(resultString)
        case .failure(let error):
            return .failure(error)
        }
    }

    open func executeData() -> Result<Data, RageError> {
        let result = self.execute()

        switch result {
        case .success(let response):
            guard let data = response.data else {
                return .failure(RageError(type: RageErrorType.emptyNetworkResponse))
            }

            return .success(data)
        case .failure(let error):
            return .failure(error)
        }
    }

    open func enqueue(_ completion: @escaping (Result<RageResponse, RageError>) -> Void) {
        DispatchQueue.global(qos: .background).async(execute: {
            let result = self.execute()

            DispatchQueue.main.async(execute: {
                completion(result)
            })
        })
    }

    open func enqueueString(_ completion: @escaping (Result<String, RageError>) -> Void) {
        DispatchQueue.global(qos: .background).async(execute: {
            let result = self.executeString()

            DispatchQueue.main.async(execute: {
                completion(result)
            })
        })
    }

    open func enqueueData(_ completion: @escaping (Result<Data, RageError>) -> Void) {
        DispatchQueue.global(qos: .background).async(execute: {
            let result = self.executeData()

            DispatchQueue.main.async(execute: {
                completion(result)
            })
        })
    }

}

extension RageRequest {

    // MARK: Plugins

    open func sendPluginsWillSendRequest() {
        for plugin in plugins {
            plugin.willSendRequest(self)
        }
    }

    open func sendPluginsDidSendRequest(_ rawRequest: URLRequest) {
        for plugin in plugins {
            plugin.didSendRequest(self, rawRequest: rawRequest)
        }
    }

    open func sendPluginsDidReceiveResponse(_ rageResponse: RageResponse,
                                            rawRequest: URLRequest) {
        for plugin in plugins {
            plugin.didReceiveResponse(rageResponse, rawRequest: rawRequest)
        }
    }

}

extension RageRequest {

    // MARK: Stub

    public func isStubbed() -> Bool {
        guard let stub = stubData else {
            return false
        }
        switch stub.mode {
        case .never:
            return false
        default:
            return true
        }
    }

    public func getStubData() -> Data? {
        guard let stub = stubData else {
            return nil
        }
        switch stub.mode {
        case .never:
            return nil
        case .immediate:
            return stub.data as Data
        case .delayed(let delayMillis):
            let seconds = Double(delayMillis) / 1000
            Thread.sleep(forTimeInterval: seconds)
            return stub.data as Data
        }
    }

}
