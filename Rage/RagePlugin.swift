import Foundation

public protocol RagePlugin {

    func willSendRequest(_ request: RageRequest)
    func didReceiveResponse(_ response: RageResponse, rawRequest: URLRequest)
    func didSendRequest(_ request: RageRequest, rawRequest: URLRequest)

}

public extension RagePlugin {

    func willSendRequest(_ request: RageRequest) {

    }

    func didReceiveResponse(_ response: RageResponse, rawRequest: URLRequest) {

    }

    func didSendRequest(_ request: RageRequest, rawRequest: URLRequest) {

    }

}
