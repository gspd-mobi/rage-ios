import UIKit

public class ActivityIndicatorPlugin: RagePlugin {

    public init() {
        // No operations.
    }

    public func willSendRequest(request: RageRequest) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }

    public func didReceiveResponse(response: RageResponse, rawRequest: NSURLRequest) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

}
