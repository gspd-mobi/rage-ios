import Foundation

open class MultipartRageRequest: RageRequest {

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

        let boundaryData = "\(boundary)"
        .data(using: String.Encoding.utf8)

        let extraDashesData = "--".data(using: String.Encoding.utf8)

        for (key, value) in parts {
            guard let safeBoundaryData = boundaryData else {
                break
            }

            var fileString = ""
            if let fileName = value.fileName {
                fileString = "; filename=\"\(fileName)\""
            }

            guard let contentDispositionData =
            "Content-Disposition: form-data; name=\"\(key)\"\(fileString)\r\n"
            .data(using: String.Encoding.utf8) else {
                break
            }
            guard let contentTypeData = "Content-Type: \(value.mimeType)\r\n"
            .data(using: String.Encoding.utf8) else {
                break
            }
            guard let lineTerminatorData = "\r\n".data(using: String.Encoding.utf8) else {
                break
            }

            body.append(safeBoundaryData)
            body.append(lineTerminatorData)
            body.append(contentDispositionData)
            body.append(contentTypeData)
            body.append(lineTerminatorData)
            body.append(value.object as Data)
            body.append(lineTerminatorData)
        }
        if let safeBoundaryData = boundaryData {
            body.append(safeBoundaryData)
        }
        if let safeExtraDashesData = extraDashesData {
            body.append(safeExtraDashesData)
        }
        return body as Data
    }

}
