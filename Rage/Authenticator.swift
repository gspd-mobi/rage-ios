import Foundation

public protocol Authenticator {

    func authorizeRequest(_ request: RageRequest) -> RageRequest

}
