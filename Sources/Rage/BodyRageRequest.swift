import Foundation

open class BodyRageRequest: RageRequest {

    var body: Data?

    public override init(httpMethod: HttpMethod,
                         baseUrl: String?) {
        super.init(httpMethod: httpMethod, baseUrl: baseUrl)
    }

    public override init(requestDescription: RequestDescription) {
        super.init(requestDescription: requestDescription)
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
        if isAuthorized {
            _ = authenticator?.authorizeRequest(self)
        }
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
