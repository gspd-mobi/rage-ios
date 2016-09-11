import Foundation
import Result

public protocol ErrorHandler {

    var enabled: Bool { get set }
    
    func isError(error: RageError) -> Bool

    func handleError(request: RageRequest, result: Result<RageResponse, RageError>)
                    -> Result<RageResponse, RageError>

}

public extension ErrorHandler {

    func isError(error: RageError) -> Bool {
        return false
    }

    func handleError(request: RageRequest, result: Result<RageResponse, RageError>)
                    -> Result<RageResponse, RageError> {
        return result
    }

}
