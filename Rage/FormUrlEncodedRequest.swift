import Foundation
import Result

public class FormUrlEncodedRequest: RageRequest {

    var fieldParameters = [String: String]()
    var body: NSData?

    public init(from request: RageRequest) {
        super.init(httpMethod: request.httpMethod, baseUrl: request.baseUrl)
        self.methodPath = request.methodPath
        self.queryParameters = request.queryParameters
        self.pathParameters = request.pathParameters
        self.headers = request.headers
        self.authenticator = request.authenticator
        self.needAuth = request.needAuth
        self.timeoutMillis = request.timeoutMillis
        self.plugins = request.plugins
    }

    public func field<T>(key: String, _ value: T) -> FormUrlEncodedRequest {
        fieldParameters[key] = String(value)
        return self
    }

    public func fieldDictionary<T>(dictionary: [String:T]) -> FormUrlEncodedRequest {
        for (key, value) in dictionary {
            fieldParameters[key] = String(value)
        }
        return self
    }

    public override func execute() -> Result<RageResponse, RageError> {
        body = ParamsBuilder.buildUrlEncodedString(fieldParameters)
        .dataUsingEncoding(NSUTF8StringEncoding)
        return super.execute()
    }

    public override func rawRequest() -> NSURLRequest {
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

        if httpMethod.hasBody() {
            request.HTTPBody = body
        }

        return request
    }

}
