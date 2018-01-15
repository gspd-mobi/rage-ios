import Foundation

class TestPlugin: RagePlugin {

}

class TestIncrementPlugin: RagePlugin {

    var didReceiveResponseCounter = 0
    var didSendRequestCounter = 0
    var willSendRequestCounter = 0

    func didReceiveResponse(_ response: RageResponse, rawRequest: URLRequest) {
        didReceiveResponseCounter += 1
    }

    func didSendRequest(_ request: RageRequest, rawRequest: URLRequest) {
        didSendRequestCounter += 1
    }

    func willSendRequest(_ request: RageRequest) {
        willSendRequestCounter += 1
    }

}
