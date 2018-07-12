import Foundation

struct QueryParam {
    var value: String?
    var encoded: Bool

    init(value: String?, encoded: Bool = true) {
        self.value = value
        self.encoded = encoded
    }
}
