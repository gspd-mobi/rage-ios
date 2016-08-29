import Foundation

public class RageResponse {

    public let request: RageRequest
    public let data: NSData?
    public let response: NSURLResponse?
    public let error: NSError?

    init(request: RageRequest, data: NSData?, response: NSURLResponse?, error: NSError?) {
        self.request = request
        self.data = data
        self.response = response
        self.error = error
    }

}

extension RageResponse {

    func statusCode() -> Int? {
        if let httpResponse = response as? NSHTTPURLResponse {
            return httpResponse.statusCode
        }
        if let safeError = error {
            return safeError.code
        }
        return nil
    }

    func isSuccess() -> Bool {
        if let status = statusCode() {
            return 200 ..< 300 ~= status
        }
        return false
    }

}
