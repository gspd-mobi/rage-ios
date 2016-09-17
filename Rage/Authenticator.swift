import Foundation

public protocol Authenticator {

    func authorizeRequest(request: RageRequest) -> RageRequest

}
