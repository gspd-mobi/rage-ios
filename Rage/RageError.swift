import Foundation

public class RageError: ErrorType {

    let message: String?

    let response: RageResponse?

    init(_ response: RageResponse?) {
        self.response = response
        self.message = nil
    }

    init(_ message: String?) {
        self.message = message
        self.response = nil
    }

}

public class HttpError: RageError {

}

public class NetworkError: RageError {

}

extension RageError {

    public func statusCode() -> Int? {
        return response?.statusCode()
    }

    public func description() -> String {
        return self.response?.error?.description ?? ""
    }

}
