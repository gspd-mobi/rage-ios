import Foundation

public protocol RagePlugin {
    
    func willSendRequest(request: RageRequest)
    func didReceiveResponse(response: RageResponse)
    func didSendRequest(request: RageRequest, raw: NSURLRequest)
    
}

public extension RagePlugin {

    func willSendRequest(request: RageRequest) {

    }

    func didReceiveResponse(response: RageResponse) {

    }

    func didSendRequest(request: RageRequest, raw: NSURLRequest) {

    }

}