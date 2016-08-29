import Foundation

public enum RageErrorType {
    case Raw
    case EmptyNetworkResponse
    case Configuration
    case Http
    case NetworkError
}

public class RageError: ErrorType {

    public let type: RageErrorType

    public var rageResponse: RageResponse? = nil

    public var message: String? = nil

    init(type: RageErrorType, rageResponse: RageResponse?) {
        self.rageResponse = rageResponse
        self.type = type
    }

    init(type: RageErrorType, message: String? = nil) {
        self.type = type
        self.message = message
    }

}

extension RageError {

    public func statusCode() -> Int? {
        return rageResponse?.statusCode()
    }

}
