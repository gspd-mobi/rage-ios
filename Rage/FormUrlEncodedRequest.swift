import Foundation
import Result

public class FieldParameter {

    var encoded: Bool = false
    var value: String

    init(value: String, encoded: Bool = false) {
        self.value = value
        self.encoded = encoded
    }

}

public class FormUrlEncodedRequest: RageRequest {

    var fieldParameters = [String: FieldParameter]()
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

    public func field<T>(key: String, _ value: T?, encoded: Bool = false) -> FormUrlEncodedRequest {
        guard let safeObject = value else {
            fieldParameters.removeValueForKey(key)
            return self
        }
        fieldParameters[key] = FieldParameter(value: String(safeObject), encoded: encoded)
        return self
    }

    public func fieldDictionary(dictionary: [String: FieldParameter?]) -> FormUrlEncodedRequest {
        for (key, value) in dictionary {
            if let safeObject = value {
                fieldParameters[key] = safeObject
            } else {
                fieldParameters.removeValueForKey(key)
            }
        }
        return self
    }

    public override func execute() -> Result<RageResponse, RageError> {
        body = ParamsBuilder().buildUrlEncodedString(fieldParameters)
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
