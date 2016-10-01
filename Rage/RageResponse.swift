import Foundation

open class RageResponse {

    open let request: RageRequest
    open let data: Data?
    open let response: URLResponse?
    open let error: NSError?

    init(request: RageRequest, data: Data?, response: URLResponse?, error: NSError?) {
        self.request = request
        self.data = data
        self.response = response
        self.error = error
    }

}

extension RageResponse {

    func statusCode() -> Int? {
        if let httpResponse = response as? HTTPURLResponse {
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
