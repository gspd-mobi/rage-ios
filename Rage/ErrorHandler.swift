import Foundation
import Result

open class ErrorHandler {

    open var enabled: Bool = true

    public init() {
        // No operations.
    }

    open func canHandleError(_ error: RageError) -> Bool {
        return false
    }

    open func handleErrorForRequest(_ request: RageRequest,
                               result: Result<RageResponse, RageError>)
        -> Result<RageResponse, RageError> {
            return result
    }

}
