import Foundation

public class MultipartRageRequest: RageRequest {

    var parts = [String: TypedObject]()

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
            return self
        }
        parts[name] = safeObject
        return self
    }

    private func generateBoundary() -> String {
        return "RageBoundary-\(NSUUID().UUIDString)"
    }

    override public func rawRequest() -> NSURLRequest {
        let urlString = url()
        let optionalUrl = NSURL(string: urlString)
        guard let url = optionalUrl else {
            preconditionFailure(self.wrongUrlErrorMessage)
        }

        let request = NSMutableURLRequest(URL: url)
        let boundary = generateBoundary()
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

            for (key, value) in parts {
                guard let boundaryString = "--\(boundary)\r\n"
                    .dataUsingEncoding(NSUTF8StringEncoding) else {
                    break
                }
                guard let contentDisposition =
                    "Content-Disposition:form-data; name=\"\(key)\"; filename=\(key)\r\n"
                    .dataUsingEncoding(NSUTF8StringEncoding) else {
                    break
                }
                guard let contentType = "Content-Type: \(value.mimeType)\r\n"
                    .dataUsingEncoding(NSUTF8StringEncoding) else {
                    break
                }
                guard let lineTerminator = "\r\n".dataUsingEncoding(NSUTF8StringEncoding) else {
                    break
                }

                body.appendData(boundaryString)
                body.appendData(contentDisposition)
                body.appendData(contentType)
                body.appendData(value.object)
                body.appendData(lineTerminator)
            }
            if let boundaryString2 = "--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding) {
                body.appendData(boundaryString2)
            }

            request.HTTPBody = body
        }
        return request
    }

}
