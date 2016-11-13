import Foundation
import Result

open class FieldParameter {

    var encoded: Bool = false
    var value: String

    init(value: String, encoded: Bool = false) {
        self.value = value
        self.encoded = encoded
    }

}

extension FieldParameter {

    func valueWithEncodingIfNeeded() -> String {
        if encoded {
            return value.urlEncoded()
        }
        return value
    }

}

open class FormUrlEncodedRequest: RageRequest {

    var fieldParameters = [String: FieldParameter]()
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
        _ = contentType(.urlEncoded)
    }

    open func field<T>(_ key: String, _ value: T?, encoded: Bool = false) -> FormUrlEncodedRequest {
        guard let safeObject = value else {
            fieldParameters.removeValue(forKey: key)
            return self
        }
        fieldParameters[key] = FieldParameter(value: String(describing: safeObject),
                                              encoded: encoded)
        return self
    }

    open func fieldDictionary(_ dictionary: [String: FieldParameter?]) -> FormUrlEncodedRequest {
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
