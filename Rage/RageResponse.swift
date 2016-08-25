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
