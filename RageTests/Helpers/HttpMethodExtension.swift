import Foundation

extension HttpMethod: Equatable {

}

public func == (lhs: HttpMethod, rhs: HttpMethod) -> Bool {
    switch (lhs, rhs) {
    case (.get, .get),
         (.post, .post),
         (.put, .put),
         (.delete, .delete),
         (.patch, .patch),
         (.head, .head):
        return true
    case (.custom(let customMethod1), .custom(let customMethod2)):
        return customMethod1 == customMethod2
    default:
        return false
    }
}
