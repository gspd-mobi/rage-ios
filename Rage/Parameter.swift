import Foundation

public struct Parameter {
    var value: String?
    var encoded: Bool

    public init(value: String?, encoded: Bool = true) {
        self.value = value
        self.encoded = encoded
    }
}

public extension Parameter {

    public func valueWithEncodingIfNeeded() -> String? {
        if encoded {
            return value?.urlEncoded()
        }
        return value
    }

}
