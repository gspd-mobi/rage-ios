import Foundation

public enum LogLevel {
    case None
    case Medium
    case Full
}

public class LoggingPlugin: RagePlugin {

    var logLevel: LogLevel

    public init(logLevel: LogLevel) {
        self.logLevel = logLevel
    }

    public func didReceiveResponse(response: RageResponse) {
        logResponse(response)
    }

    public func didSendRequest(request: RageRequest, raw: NSURLRequest) {
        logRequestUrl(request.isStubbed(), httpMethod: request.httpMethod, url: request.url())
        logHeaders(raw.allHTTPHeaderFields)
        logBody(raw.HTTPBody)
    }


    private func logRequestUrl(stubbed: Bool, httpMethod: HttpMethod, url: String) {
        switch logLevel {
        case .Full,
             .Medium:
            let stubbedString = stubbed ? "STUB " : ""
            print(">>> \(stubbedString)\(httpMethod.stringValue()) \(url)")
            break
        case .None:
            break
        }
    }

    private func logHeaders(headers: [String:String]?) {
        switch logLevel {
        case .Full:
            if let headers = headers {
                for (key, value) in headers {
                    print("\(key): \(value)")
                }
            }
            break
        case .Medium,
             .None:
            break
        }
    }

    private func logResponse(rageResponse: RageResponse) {

        let httpMethod = rageResponse.request.httpMethod
        let url = rageResponse.request.url()
        let data = rageResponse.data
        let response = rageResponse.response

        switch logLevel {
        case .Full:
            print("<<< \(httpMethod.stringValue()) \(url)")
            guard let data = data else {
                print("Empty response data")
                return
            }

            guard let httpResponse = response as? NSHTTPURLResponse else {
                print("Empty response")
                return
            }

            print(httpResponse.statusCode)

            for (key, value) in httpResponse.allHeaderFields {
                print("\(key): \(value)")
            }

            let resultString = String(data: data, encoding: NSUTF8StringEncoding)!
            if isJson(httpResponse) {
                print(data.prettyJson() ?? "")
            } else {
                print(resultString)
            }
            break
        case .Medium:
            print("<<< \(httpMethod.stringValue()) \(url)")
            guard let data = data else {
                print("Empty response data")
                return
            }

            guard let httpResponse = response as? NSHTTPURLResponse else {
                print("Empty response")
                return
            }

            print(httpResponse.statusCode)

            let resultString = String(data: data, encoding: NSUTF8StringEncoding)!
            if isJson(httpResponse) {
                print(data.prettyJson() ?? "")
            } else {
                print(resultString)
            }
            break
        case .None:
            break
        }
    }

    private func isJson(httpResponse: NSHTTPURLResponse) -> Bool {
        let contentTypeHeader = httpResponse.allHeaderFields["Content-Type"]
        guard let contentTypeStringValue = contentTypeHeader as? String else {
            return false
        }
        return contentTypeStringValue.containsString("application/json")
    }

    func logBody(data: NSData?) {
        guard let data = data else {
            return
        }

        switch logLevel {
        case .Full:
            let resultString = String(data: data, encoding: NSUTF8StringEncoding)!
            print("Body:\n\(resultString)")
            break
        case .Medium:
            let resultString = String(data: data, encoding: NSUTF8StringEncoding)!
            print("Body:")
            print(resultString.substringToIndex(resultString.startIndex.advancedBy(256)) + "...")
            print("Body to long to show. Use LogLevel.Full to show full body.")
            break
        case .None:
            break
        }

    }
}
