import Foundation

public enum HttpMethod {
    case get
    case post
    case put
    case delete
    case patch
    case head
    case custom(String)

    func stringValue() -> String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        case .patch:
            return "PATCH"
        case .head:
            return "HEAD"
        case .custom(let customMethod):
            return customMethod
        }
    }

    func hasBody() -> Bool {
        switch self {
        case .get,
             .head:
            return false
        default:
            return true
        }

    }

}
