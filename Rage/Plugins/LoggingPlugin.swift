import Foundation

public enum LogLevel {
    case none
    case basic
    case medium
    case full
}

public class LoggingPlugin: RagePlugin {

    var logLevel: LogLevel

    public init(logLevel: LogLevel) {
        self.logLevel = logLevel
    }

    public func didReceiveResponse(response: RageResponse, rawRequest: NSURLRequest) {
        let stubbed = response.request.isStubbed()
        logResponse(response, rawRequest: rawRequest, stubbed: stubbed)
    }

    public func didSendRequest(request: RageRequest, rawRequest: NSURLRequest) {
        logRequest(request, rawRequest: rawRequest)
    }

    private func logRequest(request: RageRequest, rawRequest: NSURLRequest) {
        let stubbed = request.isStubbed()
        logUrlForRawRequest(rawRequest, stubbed: stubbed)
        logHeadersForRawRequest(rawRequest)
        logBodyForRawRequest(rawRequest)
    }

    private func logUrlForRawRequest(raw: NSURLRequest, stubbed: Bool = false) {
        switch logLevel {
        case .full,
             .medium,
             .basic:
            let stubbedString = generateStubString(stubbed)
            let httpMethod = raw.HTTPMethod ?? ""
            let url = raw.URL?.absoluteString ?? ""
            print("--> \(stubbedString)\(httpMethod) \(url)")
            break
        case .none:
            break
        }
    }

    private func logHeadersForRawRequest(raw: NSURLRequest) {
        let headers = raw.allHTTPHeaderFields
        switch logLevel {
        case .full:
            guard let headers = headers else {
                break
            }
            for (key, value) in headers {
                print("\(key): \(value)")
            }
            break
        case .medium,
             .basic,
             .none:
            break
        }
    }

    private func logResponse(rageResponse: RageResponse, rawRequest: NSURLRequest,
                             stubbed: Bool = false) {

        let httpMethod = rawRequest.HTTPMethod ?? ""
        let url = rawRequest.URL?.absoluteString ?? ""
        let data = rageResponse.data
        let response = rageResponse.response

        switch logLevel {
        case .full,
             .medium:
            let stubbedString = generateStubString(stubbed)
            print("<-- \(stubbedString)\(httpMethod) \(url)")

            guard let data = data else {
                print("Empty response data")
                return
            }

            if stubbed {
                guard let resultString = String(data: data, encoding: NSUTF8StringEncoding) else {
                    break
                }
                print(resultString)
            } else {
                guard let httpResponse = response as? NSHTTPURLResponse else {
                    print("Empty response")
                    return
                }

                print(httpResponse.statusCode)

                for (key, value) in httpResponse.allHeaderFields {
                    print("\(key): \(value)")
                }

                if isJson(httpResponse) {
                    print(data.prettyJson() ?? "")
                } else {
                    guard let resultString = String(data: data,
                                                    encoding: NSUTF8StringEncoding) else {
                        break
                    }
                    print(resultString)
                }
            }
            break
        case .basic,
             .none:
            break
        }
    }

    func logBodyForRawRequest(raw: NSURLRequest) {
        guard let data = raw.HTTPBody else {
            return
        }

        switch logLevel {
        case .full,
             .medium:
            guard let resultString = String(data: data, encoding: NSUTF8StringEncoding) else {
                break
            }
            print()
            print(resultString)
            break
        case .basic,
             .none:
            break
        }

    }

    private func generateStubString(stubbed: Bool) -> String {
        return stubbed ? "STUB " : ""
    }

    private func isJson(httpResponse: NSHTTPURLResponse) -> Bool {
        let contentTypeHeader = httpResponse.allHeaderFields["Content-Type"]
        guard let contentTypeStringValue = contentTypeHeader as? String else {
            return false
        }
        return contentTypeStringValue.containsString("application/json")
    }

}
