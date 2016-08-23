import Foundation

public enum HttpMethod {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
    case HEAD
    case CUSTOM(String)

    func stringValue() -> String {
        switch self {
        case GET:
            return "GET"
        case POST:
            return "POST"
        case PUT:
            return "PUT"
        case DELETE:
            return "DELETE"
        case PATCH:
            return "PATCH"
        case HEAD:
            return "HEAD"
        case CUSTOM(let customMethod):
            return customMethod
        }
    }

    func hasBody() -> Bool {
        switch self {
        case GET,
             HEAD:
            return false
        default:
            return true
        }

    }

}
