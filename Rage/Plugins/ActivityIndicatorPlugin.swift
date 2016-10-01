import UIKit

open class ActivityIndicatorPlugin: RagePlugin {

    public init() {
        // No operations.
    }

    open func willSendRequest(_ request: RageRequest) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    open func didReceiveResponse(_ response: RageResponse, rawRequest: URLRequest) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}
