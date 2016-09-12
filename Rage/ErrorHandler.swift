import Foundation
import Result

public protocol ErrorHandler {

    var enabled: Bool { get set }
    
    func canHandleError(error: RageError) -> Bool

    func handleErrorForRequest(request: RageRequest,
                               result: Result<RageResponse, RageError>)
        -> Result<RageResponse, RageError>

}

public extension ErrorHandler {

    func canHandleError(error: RageError) -> Bool {
        return false
    }

    func handleErrorForRequest(request: RageRequest,
                               result: Result<RageResponse, RageError>)
        -> Result<RageResponse, RageError> {
        return result
    }

}
