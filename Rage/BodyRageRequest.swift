import Foundation
import Result

open class BodyRageRequest: RageRequest {

    var body: Data?

    public init(from request: RageRequest) {
        super.init(httpMethod: request.httpMethod, baseUrl: request.baseUrl)
        self.methodPath = request.methodPath
        self.queryParameters = request.queryParameters
        self.pathParameters = request.pathParameters
        self.headers = request.headers
        self.authenticator = request.authenticator
        self.timeoutMillis = request.timeoutMillis
        self.plugins = request.plugins
    }

    open func bodyData(_ value: Data) -> BodyRageRequest {
        body = value
        return self
    }

    open func bodyString(_ value: String) -> BodyRageRequest {
        body = value.data(using: String.Encoding.utf8)
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
