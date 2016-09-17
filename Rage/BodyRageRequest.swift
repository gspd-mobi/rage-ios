import Foundation
import Result

public class BodyRageRequest: RageRequest {

    var body: NSData?

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

    public func bodyData(value: NSData) -> BodyRageRequest {
        body = value
        return self
    }

    public func bodyString(value: String) -> BodyRageRequest {
        body = value.dataUsingEncoding(NSUTF8StringEncoding)
        return self
    }

    public override func rawRequest() -> NSURLRequest {
        let url = URLBuilder().fromRequest(self)
        let request = NSMutableURLRequest(URL: url)
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.HTTPMethod = httpMethod.stringValue()

        if httpMethod.hasBody() {
            request.HTTPBody = body
        }

        return request
    }

}
