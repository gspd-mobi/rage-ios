import Foundation

class TestAuthenticator: Authenticator {

    func authorizeRequest(request: RageRequest) -> RageRequest {
        // test implementation / do nothing
        return request
    }

}