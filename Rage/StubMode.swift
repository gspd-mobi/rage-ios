import Foundation

public enum StubMode {

    case immediate
    case delayed(Int)
    case never

    func delay() -> Int {
        switch self {
        case delayed(let delayMillis):
            return delayMillis
        default:
            return 0
        }
    }

}
