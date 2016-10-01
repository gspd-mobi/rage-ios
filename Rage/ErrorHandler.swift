import Foundation
import Result

public protocol ErrorHandler {

    var enabled: Bool { get set }

    func canHandleError(_ error: RageError) -> Bool

    func handleErrorForRequest(_ request: RageRequest,
                               result: Result<RageResponse, RageError>)
        -> Result<RageResponse, RageError>

}

public extension ErrorHandler {

    func canHandleError(_ error: RageError) -> Bool {
        return false
    }

    func handleErrorForRequest(_ request: RageRequest,
                               result: Result<RageResponse, RageError>)
        -> Result<RageResponse, RageError> {
        return result
    }

}
