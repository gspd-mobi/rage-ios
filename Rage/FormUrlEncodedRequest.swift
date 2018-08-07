import Foundation
import Result

open class FormUrlEncodedRequest: RageRequest {

    var fieldParameters = [String: Parameter]()
    var body: Data?

    public init(from request: RageRequest) {
        super.init(httpMethod: request.httpMethod, baseUrl: request.baseUrl)
        self.methodPath = request.methodPath
        self.queryParameters = request.queryParameters
        self.pathParameters = request.pathParameters
        self.headers = request.headers
        self.isAuthorized = request.isAuthorized
        self.authenticator = request.authenticator
        self.plugins = request.plugins
        self.session = request.session
        _ = contentType(.urlEncoded)
    }

    open func field<T>(_ key: String, _ value: T?, encoded: Bool = false) -> FormUrlEncodedRequest {
        guard let safeObject = value else {
            fieldParameters.removeValue(forKey: key)
            return self
        }
        fieldParameters[key] = SingleParameter(value: String(describing: safeObject),
                                               encoded: encoded)
        return self
    }

    open func fieldDictionary(_ dictionary: [String: Parameter?]) -> FormUrlEncodedRequest {
        for (key, value) in dictionary {
            if let safeObject = value {
                fieldParameters[key] = safeObject
            } else {
                fieldParameters.removeValue(forKey: key)
            }
        }
        return self
    }

    open override func execute() -> Result<RageResponse, RageError> {
        body = ParamsBuilder().stringFromFieldParameters(fieldParameters).utf8Data()
        return super.execute()
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

        body = ParamsBuilder().stringFromFieldParameters(fieldParameters).utf8Data()
        if httpMethod.hasBody() {
            request.httpBody = body
        }

        return request as URLRequest
    }

}
