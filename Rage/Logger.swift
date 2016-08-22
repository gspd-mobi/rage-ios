import Foundation

public class Logger {

    var logLevel: LogLevel

    init(logLevel: LogLevel) {
        self.logLevel = logLevel
    }

    func logRequestUrl(httpMethod: HttpMethod, url: String) {
        switch logLevel {
        case .Full,
             .NoHeaders:
            print(">>> \(httpMethod) \(url)")
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
        case .NoHeaders,
             .None:
            break
        }
    }

    func logResponse(httpMethod: HttpMethod, url: String, data: NSData?, response: NSURLResponse?) {
        switch logLevel {
        case .Full:
            print("<<< \(httpMethod) \(url)")
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
        case .NoHeaders:
            print("<<< \(httpMethod) \(url)")
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

}
