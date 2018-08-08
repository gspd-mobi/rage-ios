import Foundation

public enum LogLevel: Int {

    case none = 0
    case basic = 1
    case medium = 2
    case full = 3

}

open class LoggingPlugin: RagePlugin {

    var logLevel: LogLevel
    var prettify = true

    public init(logLevel: LogLevel, prettify: Bool = true) {
        self.logLevel = logLevel
        self.prettify = prettify
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
        case .medium,
             .basic,
             .none:
            break
        }
    }

    fileprivate func logResponse(_ rageResponse: RageResponse,
                                 rawRequest: URLRequest,
                                 stubbed: Bool = false) {
        switch logLevel {
        case .full:
            logResponseFull(rageResponse, rawRequest: rawRequest, stubbed: stubbed)
        case .medium:
            logResponseMedium(rageResponse, rawRequest: rawRequest, stubbed: stubbed)
        case .basic,
             .none:
            break
        }
    }

    func logResponseFull(_ rageResponse: RageResponse,
                         rawRequest: URLRequest,
                         stubbed: Bool = false) {
        let httpMethod = rawRequest.httpMethod ?? ""
        let url = rawRequest.url?.absoluteString ?? ""
        let optionalData = rageResponse.data
        let response = rageResponse.response

        let stubbedString = generateStubString(stubbed)
        let time = Int(rageResponse.timeMillis)
        print("<-- \(stubbedString)\(httpMethod) \(url) (\(time) ms)")

        guard let data = optionalData else {
            print("Empty response data")
            return
        }

        if stubbed {
            guard let resultString = String(data: data as Data,
                                            encoding: String.Encoding.utf8) else {
                                                return
            }
            print(resultString)
        } else {
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Empty response")
                return
            }

            logStatusCode(httpResponse.statusCode)

            for (key, value) in httpResponse.allHeaderFields {
                print("\(key): \(value)")
            }

            if prettify && isJson(httpResponse) {
                print(data.prettyJsonString() ?? "")
            } else {
                guard let resultString = String(data: data as Data,
                                                encoding: String.Encoding.utf8) else {
                                                    return
                }
                print(resultString)
            }
        }
    }

    func logResponseMedium(_ rageResponse: RageResponse,
                           rawRequest: URLRequest,
                           stubbed: Bool = false) {
        let httpMethod = rawRequest.httpMethod ?? ""
        let url = rawRequest.url?.absoluteString ?? ""
        let optionalData = rageResponse.data
        let response = rageResponse.response

        let stubbedString = generateStubString(stubbed)
        let time = Int(rageResponse.timeMillis)
        print("<-- \(stubbedString)\(httpMethod) \(url) (\(time) ms)")

        guard let data = optionalData else {
            print("Empty response data")
            return
        }

        if stubbed {
            guard let resultString = String(data: data as Data,
                                            encoding: String.Encoding.utf8) else {
                                                return
            }
            print(resultString)
        } else {
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Empty response")
                return
            }

            logStatusCode(httpResponse.statusCode)

            if prettify && isJson(httpResponse) {
                print(data.prettyJsonString() ?? "")
            } else {
                guard let resultString = String(data: data as Data,
                                                encoding: String.Encoding.utf8) else {
                                                    return
                }
                print(resultString)
            }
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
        case .basic,
             .none:
            break
        }
    }

    func logStatusCode(_ code: Int) {
        var codeString = "Status code: \(code)"
        switch code {
        case 100 ..< 200:
            codeString += " ℹ️"
        case 200 ..< 300:
            codeString += " ✅"
        case 300 ..< 400:
            codeString += " ➡️"
        case 400 ..< 500:
            codeString += " ❌"
        case 500 ..< 600:
            codeString += " 🆘"
        default:
            break
        }
        print(codeString)
    }

    fileprivate func generateStubString(_ stubbed: Bool) -> String {
        return stubbed ? " " : ""
    }

    fileprivate func isJson(_ httpResponse: HTTPURLResponse) -> Bool {
        let contentTypeHeader = httpResponse.allHeaderFields[ContentType.key]
        guard let contentTypeStringValue = contentTypeHeader as? String else {
            return false
        }
        return contentTypeStringValue.contains("application/json")
    }

}
