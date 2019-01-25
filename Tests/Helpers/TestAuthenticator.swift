import Foundation

class TestAuthenticator: Authenticator {

    func authorizeRequest(_ request: RageRequest) -> RageRequest {
        // test implementation / do nothing
        return request
    }

}

class TestActiveAuthenticator: Authenticator {

    let token: String

    init(token: String) {
        self.token = token
    }

    func authorizeRequest(_ request: RageRequest) -> RageRequest {
        return request.header("Authorization", token)
    }

}
