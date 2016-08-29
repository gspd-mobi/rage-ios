import Foundation
import Result

public class RageRequest {

    let jsonParsingErrorMessage = "Couldn't parse object from JSON"
    let wrongUrlErrorMessage = "Wrong url provided for request"
    let wrongHttpMethodForBodyErrorMessage = "Can't add body to request with such HttpMethod"

    var httpMethod: HttpMethod
    var baseUrl: String
    var methodPath: String?
    var queryParameters = [String: String]()
    var pathParameters = [String: String]()
    var fieldParameters = [String: String]()
    var headers: [String:String]
    var body: NSData?

    var authenticator: Authenticator?
    var needAuth = false

    var timeoutMillis: Int
    var plugins: [RagePlugin]

    init(requestDescription: RequestDescription,
         plugins: [RagePlugin]) {
        self.httpMethod = requestDescription.httpMethod
        self.baseUrl = requestDescription.baseUrl
        self.methodPath = requestDescription.path
        self.headers = requestDescription.headers
        self.headers["Content-Type"] = requestDescription.contentType.stringValue()

        self.authenticator = requestDescription.authenticator
        self.needAuth = requestDescription.authorized

        self.timeoutMillis = requestDescription.timeoutMillis
        self.plugins = plugins
    }

    // MARK: Parameters

    public func query<T>(key: String, _ value: T?) -> RageRequest {
        guard let safeValue = value else {
            queryParameters.removeValueForKey(key)
            return self
        }
        queryParameters[key] = String(safeValue)
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
        self.headers["Content-Type"] = contentType.stringValue()
        return self
    }

    public func authorized(authenticator: Authenticator) -> RageRequest {
        self.authenticator = authenticator
        return authorized()
    }

    public func authorized() -> RageRequest {
        if let safeAuthenticator = authenticator {
            return safeAuthenticator.authorizeRequest(self)
        } else {
            preconditionFailure("Can't create authorized request without Authenticator provided")
        }
    }

    // MARK: Configurations

    public func withTimeoutMillis(timeoutMillis: Int) -> RageRequest {
        self.timeoutMillis = timeoutMillis
        return self
    }

    // MARK: Requests

    private func createSession() -> NSURLSession {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let timeoutSeconds = Double(timeoutMillis) / 1000.0
        configuration.timeoutIntervalForRequest = timeoutSeconds
        configuration.timeoutIntervalForResource = timeoutSeconds

        return NSURLSession(configuration: configuration)
    }

    private func prepareParameters() {
        if body == nil {
            body = ParamsBuilder.buildUrlEncodedString(fieldParameters)
            .dataUsingEncoding(NSUTF8StringEncoding)
        }
    }

    public func syncResult() -> Result<RageResponse, RageError> {
        let urlString = url()
        let optionalUrl = NSURL(string: urlString)
        guard let url = optionalUrl else {
            preconditionFailure(self.wrongUrlErrorMessage)
        }
        prepareParameters()

        let session = createSession()

        plugins.forEach {
            $0.willSendRequest(self)
        }

        let (data, response, error) = session.synchronousDataTaskWithURL(httpMethod,
                url: url,
                headers: headers,
                bodyData: body)

        let rageResponse = RageResponse(request: self, data: data, response: response, error: error)

        plugins.forEach {
            $0.didReceiveResponse(rageResponse)
        }

        if rageResponse.isSuccess() {
            return .Success(rageResponse)
        } else {
            return .Failure(createErrorFromResponse(rageResponse))
        }
    }

    public func asyncResult(completion: (Result<RageResponse, RageError>) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            let result = self.syncResult()

            dispatch_async(dispatch_get_main_queue(), {
                return result
            })
        })
    }

    private func createErrorFromResponse(rageResponse: RageResponse) -> RageError {
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
}
