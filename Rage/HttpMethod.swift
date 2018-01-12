import Foundation

public enum HttpMethod {

    case get
    case post
    case put
    case delete
    case patch
    case head
    case custom(String, Bool)

    public func stringValue() -> String {
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
        case .custom(let customMethod, _):
            return customMethod
        }
    }

    public func hasBody() -> Bool {
        switch self {
        case .get,
             .head:
            return false
        case .custom(_, let hasBody):
            return hasBody
        default:
            return true
        }
    }

}
