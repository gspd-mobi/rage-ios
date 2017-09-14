import Foundation

open class MultipartRageRequest: RageRequest {

    open class Part {
        let name: String
        let object: TypedObject

        init(name: String, object: TypedObject) {
            self.name = name
            self.object = object
        }
    }

    static let boundaryCreateErrorMessage = "Boundary can't be created for Multipart Request"

    var parts: [Part] = []
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
        guard let object = object else {
            parts = parts.filter { $0.name != name }
            return self
        }
        parts.append(Part(name: name, object: object))
        return self
    }

    open func boundary(_ boundary: String?) -> MultipartRageRequest {
        self.customBoundary = boundary
        return self
    }

    fileprivate func makeBoundary() -> String {
        return "--rage.boundary-\(UUID().uuidString)"
    }

    override open func rawRequest() -> URLRequest {
        let url = URLBuilder().fromRequest(self)
        let request = NSMutableURLRequest(url: url)
        let boundary = customBoundary ?? makeBoundary()
        for (key, value) in headers {
            if key == "Content-Type" {
                request.addValue("\(value); boundary=\(boundary)", forHTTPHeaderField: key)
            } else {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        request.httpMethod = httpMethod.stringValue()

        if httpMethod.hasBody() {
            request.httpBody = makeBodyData(withBoundary: boundary)
        }
        return request as URLRequest
    }

    fileprivate func makeBodyData(withBoundary boundary: String) -> Data {
        let body = NSMutableData()

        guard let boundaryData = boundary.utf8Data(),
              let extraDashesData = "--".utf8Data(),
              let lineTerminatorData = "\r\n".utf8Data() else {
            preconditionFailure(MultipartRageRequest.boundaryCreateErrorMessage)
        }

        for part in parts {
            var contentDispositionString = "Content-Disposition: form-data; name=\"\(part.name)\""
            if let fileName = part.object.fileName {
                contentDispositionString += "; filename=\"\(fileName)\""
            }

            guard let contentDispositionData = contentDispositionString.utf8Data() else {
                continue
            }
            guard let contentTypeData = "Content-Type: \(part.object.mimeType)".utf8Data() else {
                continue
            }
            body.append(extraDashesData)
            body.append(boundaryData)
            body.append(lineTerminatorData)
            body.append(contentDispositionData)
            body.append(lineTerminatorData)
            body.append(contentTypeData)
            body.append(lineTerminatorData)
            body.append(lineTerminatorData)
            body.append(part.object.data)
            body.append(lineTerminatorData)
        }
        body.append(extraDashesData)
        body.append(boundaryData)
        body.append(extraDashesData)
        return body as Data
    }

}
