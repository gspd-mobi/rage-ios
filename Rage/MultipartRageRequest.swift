import Foundation

public class MultipartRageRequest: RageRequest {

    var parts = [String: TypedObject]()
    var customBoundary: String?

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

        contentType(ContentType.MultipartFormData)
    }

    public func part(object: TypedObject?, name: String) -> MultipartRageRequest {
        guard let safeObject = object else {
            parts.removeValueForKey(name)
            return self
        }
        parts[name] = safeObject
        return self
    }

    public func withCustomBoundary(boundary: String?) -> MultipartRageRequest {
        self.customBoundary = boundary
        return self
    }

    private func generateBoundary() -> String {
        return "----rage.boundary-\(NSUUID().UUIDString)"
    }

    override public func rawRequest() -> NSURLRequest {
        let urlString = url()
        let optionalUrl = NSURL(string: urlString)
        guard let url = optionalUrl else {
            preconditionFailure(self.wrongUrlErrorMessage)
        }

        let request = NSMutableURLRequest(URL: url)
        let boundary = customBoundary ?? generateBoundary()
        for (key, value) in headers {
            if key == "Content-Type" {
                request.addValue("\(value); boundary=\(boundary)", forHTTPHeaderField: key)
            } else {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        request.HTTPMethod = httpMethod.stringValue()

        if httpMethod.hasBody() {
            let body = NSMutableData()

            let boundaryData = "\(boundary)"
            .dataUsingEncoding(NSUTF8StringEncoding)

            let extraDashesData = "--".dataUsingEncoding(NSUTF8StringEncoding)

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
                .dataUsingEncoding(NSUTF8StringEncoding) else {
                    break
                }
                guard let contentTypeData = "Content-Type: \(value.mimeType)\r\n"
                .dataUsingEncoding(NSUTF8StringEncoding) else {
                    break
                }
                guard let lineTerminatorData = "\r\n".dataUsingEncoding(NSUTF8StringEncoding) else {
                    break
                }

                body.appendData(safeBoundaryData)
                body.appendData(lineTerminatorData)
                body.appendData(contentDispositionData)
                body.appendData(contentTypeData)
                body.appendData(lineTerminatorData)
                body.appendData(value.object)
                body.appendData(lineTerminatorData)
            }
            if let safeBoundaryData = boundaryData {
                body.appendData(safeBoundaryData)
            }
            if let safeExtraDashesData = extraDashesData {
                body.appendData(safeExtraDashesData)
            }

            request.HTTPBody = body
        }
        return request
    }

}
