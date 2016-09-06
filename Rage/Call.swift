import Foundation
import Result

protocol Call {

    func rawRequest() -> NSURLRequest

    func execute() -> Result<RageResponse, RageError>

    func enqueue(completion: (Result<RageResponse, RageError>) -> ())

}
