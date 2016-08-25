import Foundation

public class RageResponse {

    let request: RageRequest
    let data: NSData?
    let response: NSURLResponse?
    let error: NSError?

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
        return nil
    }

    func isSuccess() -> Bool {
        if let status = statusCode() {
            return 200 ..< 400 ~= status
        }
        return false
    }
    
}
