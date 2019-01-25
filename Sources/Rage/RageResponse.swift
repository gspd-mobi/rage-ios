import Foundation

open class RageResponse {

    open let request: RageRequest
    open let data: Data?
    open let response: URLResponse?
    open let error: NSError?
    open let timeMillis: Double

    public init(request: RageRequest,
                data: Data?,
                response: URLResponse?,
                error: NSError?,
                timeMillis: Double = 0.0) {
        self.request = request
        self.data = data
        self.response = response
        self.error = error
        self.timeMillis = timeMillis
    }

}

extension RageResponse {

    public func statusCode() -> Int? {
        if let httpResponse = response as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        if let safeError = error {
            return safeError.code
        }
        return nil
    }

    public func isSuccess() -> Bool {
        if let status = statusCode() {
            return 200 ..< 300 ~= status
        }
        return false
    }

}
