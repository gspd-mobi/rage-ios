import Foundation

public protocol RagePlugin {

    func willSendRequest(request: RageRequest)
    func didReceiveResponse(response: RageResponse, rawRequest: NSURLRequest)
    func didSendRequest(request: RageRequest, rawRequest: NSURLRequest)

}

public extension RagePlugin {

    func willSendRequest(request: RageRequest) {

    }

    func didReceiveResponse(response: RageResponse, rawRequest: NSURLRequest) {

    }

    func didSendRequest(request: RageRequest, rawRequest: NSURLRequest) {

    }

}
