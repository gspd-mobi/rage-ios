import Foundation
import Result

protocol Call {

    func rawRequest() -> URLRequest

    func execute() -> Result<RageResponse, RageError>

    func enqueue(_ completion: (Result<RageResponse, RageError>) -> ())

}
