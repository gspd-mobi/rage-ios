import Foundation

open class RageResponse {

    public let request: RageRequest
    public let data: Data?
    public let response: URLResponse?
    public let error: NSError?
    public let timeMillis: Double

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
