import UIKit

open class ActivityIndicatorPlugin: RagePlugin {

    public init() {
        // No operations.
    }

    open func willSendRequest(_ request: RageRequest) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }

    open func didReceiveResponse(_ response: RageResponse, rawRequest: URLRequest) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

}
