import Foundation
import Result

public protocol Authenticator {

    func authorizeRequest(request: RageRequest) -> RageRequest
    
}