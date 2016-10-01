import Foundation

public enum LogLevel {
    case none
    case basic
    case medium
    case full
}

open class LoggingPlugin: RagePlugin {

    var logLevel: LogLevel

    public init(logLevel: LogLevel) {
        self.logLevel = logLevel
    }

    open func didReceiveResponse(_ response: RageResponse, rawRequest: URLRequest) {
        let stubbed = response.request.isStubbed()
        logResponse(response, rawRequest: rawRequest, stubbed: stubbed)
    }

    open func didSendRequest(_ request: RageRequest, rawRequest: URLRequest) {
        logRequest(request, rawRequest: rawRequest)
    }

    fileprivate func logRequest(_ request: RageRequest, rawRequest: URLRequest) {
        let stubbed = request.isStubbed()
        logUrlForRawRequest(rawRequest, stubbed: stubbed)
        logHeadersForRawRequest(rawRequest)
        logBodyForRawRequest(rawRequest)
    }

    fileprivate func logUrlForRawRequest(_ raw: URLRequest, stubbed: Bool = false) {
        switch logLevel {
        case .full,
             .medium,
             .basic:
            let stubbedString = generateStubString(stubbed)
            let httpMethod = raw.httpMethod ?? ""
            let url = raw.url?.absoluteString ?? ""
            print("--> \(stubbedString)\(httpMethod) \(url)")
            break
        case .none:
            break
        }
    }

    fileprivate func logHeadersForRawRequest(_ raw: URLRequest) {
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

    fileprivate func logResponse(_ rageResponse: RageResponse, rawRequest: URLRequest,
                             stubbed: Bool = false) {

        let httpMethod = rawRequest.httpMethod ?? ""
        let url = rawRequest.url?.absoluteString ?? ""
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
                guard let resultString = String(data: data as Data,
                    encoding: String.Encoding.utf8) else {
                    break
                }
                print(resultString)
            } else {
                guard let httpResponse = response as? HTTPURLResponse else {
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
                    guard let resultString = String(data: data as Data,
                                                    encoding: String.Encoding.utf8) else {
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

    func logBodyForRawRequest(_ raw: URLRequest) {
        guard let data = raw.httpBody else {
            return
        }

        switch logLevel {
        case .full,
             .medium:
            guard let resultString = String(data: data, encoding: String.Encoding.utf8) else {
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

    fileprivate func generateStubString(_ stubbed: Bool) -> String {
        return stubbed ? "STUB " : ""
    }

    fileprivate func isJson(_ httpResponse: HTTPURLResponse) -> Bool {
        let contentTypeHeader = httpResponse.allHeaderFields["Content-Type"]
        guard let contentTypeStringValue = contentTypeHeader as? String else {
            return false
        }
        return contentTypeStringValue.contains("application/json")
    }

}
