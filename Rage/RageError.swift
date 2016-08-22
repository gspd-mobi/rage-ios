import Foundation

public class RageError: ErrorType {
    public var message: String?

    init(_ message: String?) {
        self.message = message
    }
}
