import Foundation
import Result

open class BodyRageRequest: RageRequest {

    static let wrongHttpMethodForBodyErrorMessage = "Can't add body to request with such HttpMethod"

    var body: Data?

    public init(from request: RageRequest) {
        super.init(httpMethod: request.httpMethod,
                   baseUrl: request.baseUrl)
        self.methodPath = request.methodPath
        self.queryParameters = request.queryParameters
        self.pathParameters = request.pathParameters
        self.headers = request.headers
        self.isAuthorized = request.isAuthorized
        self.authenticator = request.authenticator
        self.plugins = request.plugins
        self.session = request.session
    }

    open func bodyData(_ value: Data) -> BodyRageRequest {
        body = value
        return self
    }

    open func bodyString(_ value: String) -> BodyRageRequest {
        body = value.utf8Data()
        return self
    }

    open override func rawRequest() -> URLRequest {
        let url = URLBuilder().fromRequest(self)
        let request = NSMutableURLRequest(url: url)
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = httpMethod.stringValue()

        if httpMethod.hasBody() {
            request.httpBody = body
        }

        return request as URLRequest
    }

}
