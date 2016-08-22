import Foundation

public class Logger {

    var logLevel: LogLevel

    init(logLevel: LogLevel) {
        self.logLevel = logLevel
    }

    func logRequestUrl(httpMethod: HttpMethod, url: String) {
        switch logLevel {
        case .Full,
             .Medium:
            print(">>> \(httpMethod.stringValue()) \(url)")
            break
        case .None:
            break
        }
    }

    func logHeaders(headers: [String:String]) {
        switch logLevel {
        case .Full:
            headers.forEach {
                (key, value) in
                print("\(key): \(value)")
            }
            break
        case .Medium,
             .None:
            break
        }
    }

    func logResponse(httpMethod: HttpMethod, url: String, data: NSData?, response: NSURLResponse?) {
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

            httpResponse.allHeaderFields.forEach {
                (key, value) in
                print("\(key): \(value)")
            }

            let resultString = String(data: data, encoding: NSUTF8StringEncoding)!
            if ((httpResponse.allHeaderFields["Content-Type"] as? String)?.containsString("application/json") ?? false) {
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
            if ((httpResponse.allHeaderFields["Content-Type"] as? String)?.containsString("application/json") ?? false) {
                print(data.prettyJson() ?? "")
            } else {
                print(resultString)
            }
            break
        case .None:
            break
        }
    }

    func logBody(data: NSData?) {
        switch logLevel {
        case .Full:
            guard let data = data else {
                print("Empty response data")
                return
            }
            let resultString = String(data: data, encoding: NSUTF8StringEncoding)!
            print("Body:\n\(resultString)")
            break
        case .Medium:
            guard let data = data else {
                print("Empty response data")
                return
            }
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