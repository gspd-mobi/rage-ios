import Foundation

extension HttpMethod: Equatable {

}

public func == (lhs: HttpMethod, rhs: HttpMethod) -> Bool {
    switch (lhs, rhs) {
    case (.GET, .GET),
         (.POST, .POST),
         (.PUT, .PUT),
         (.DELETE, .DELETE),
         (.PATCH, .PATCH),
         (.HEAD, .HEAD):
        return true
    case (.CUSTOM(let customMethod1), .CUSTOM(let customMethod2)):
        return customMethod1 == customMethod2
    default:
        return false
    }
}
