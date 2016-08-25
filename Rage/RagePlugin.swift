import Foundation

public protocol RagePlugin {

    func willSendRequest(request: RageRequest)

    func didReceiveResponse(response: RageResponse)

}
