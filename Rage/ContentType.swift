import Foundation

public enum ContentType {

    case json
    case urlEncoded
    case multipartFormData
    case custom(String)

    func stringValue() -> String {
        switch self {
        case .json:
            return "application/json"
        case .urlEncoded:
            return "application/x-www-form-urlencoded"
        case .multipartFormData:
            return "multipart/form-data"
        case .custom(let value):
            return value
        }
    }

}
