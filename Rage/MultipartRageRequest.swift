import Foundation

open class MultipartRageRequest: RageRequest {

    static let boundaryCreateErrorMessage = "Boundary can't be created for Multipart Request"

    var parts = [String: TypedObject]()
    var customBoundary: String?

    public init(from request: RageRequest) {
        super.init(httpMethod: request.httpMethod, baseUrl: request.baseUrl)
        self.methodPath = request.methodPath
        self.queryParameters = request.queryParameters
        self.pathParameters = request.pathParameters
        self.headers = request.headers
        self.authenticator = request.authenticator
        self.timeoutMillis = request.timeoutMillis
        self.plugins = request.plugins

        _ = contentType(.multipartFormData)
    }

    open func part(_ object: TypedObject?, name: String) -> MultipartRageRequest {
        guard let safeObject = object else {
            parts.removeValue(forKey: name)
            return self
        }
        parts[name] = safeObject
        return self
    }

    open func withCustomBoundary(_ boundary: String?) -> MultipartRageRequest {
        self.customBoundary = boundary
        return self
    }

    fileprivate func generateBoundary() -> String {
        return "----rage.boundary-\(UUID().uuidString)"
    }

    override open func rawRequest() -> URLRequest {
        let url = URLBuilder().fromRequest(self)
        let request = NSMutableURLRequest(url: url)
        let boundary = customBoundary ?? generateBoundary()
        for (key, value) in headers {
            if key == "Content-Type" {
                request.addValue("\(value); boundary=\(boundary)", forHTTPHeaderField: key)
            } else {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        request.httpMethod = httpMethod.stringValue()

        if httpMethod.hasBody() {
            request.httpBody = createBodyWithBoundary(boundary)
        }
        return request as URLRequest
    }

    fileprivate func createBodyWithBoundary(_ boundary: String) -> Data {
        let body = NSMutableData()

        guard let boundaryData = boundary.makeUtf8Data() else {
            preconditionFailure(MultipartRageRequest.boundaryCreateErrorMessage)
        }

        guard let extraDashesData = "--".makeUtf8Data() else {
            preconditionFailure(MultipartRageRequest.boundaryCreateErrorMessage)
        }

        guard let lineTerminatorData = "\r\n".makeUtf8Data() else {
            preconditionFailure(MultipartRageRequest.boundaryCreateErrorMessage)
        }

        for (key, value) in parts {

            var contentDispositionString = "Content-Disposition: form-data; name=\"\(key)\""
            if let fileName = value.fileName {
                contentDispositionString += "; filename=\"\(fileName)\""
            }

            guard let contentDispositionData = contentDispositionString.makeUtf8Data() else {
                continue
            }
            guard let contentTypeData = "Content-Type: \(value.mimeType)".makeUtf8Data() else {
                continue
            }

            body.append(boundaryData)
            body.append(lineTerminatorData)
            body.append(contentDispositionData)
            body.append(lineTerminatorData)
            body.append(contentTypeData)
            body.append(lineTerminatorData)
            body.append(value.object)
            body.append(lineTerminatorData)
        }
        body.append(boundaryData)
        body.append(extraDashesData)
        return body as Data
    }

}
