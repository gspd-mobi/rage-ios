import Foundation

extension StubMode: Equatable {

}

public func == (lhs: StubMode, rhs: StubMode) -> Bool {
    switch (lhs, rhs) {
    case (.immediate, .immediate),
         (.never, .never):
        return true
    case (.delayed(let delay1), .delayed(let delay2)):
        return delay1 == delay2
    default:
        return false
    }
}

extension QueryParam: Equatable {

}

func == (lhs: QueryParam, rhs: QueryParam) -> Bool {
    return lhs.value == rhs.value && lhs.encoded == rhs.encoded
}
