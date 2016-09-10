import Foundation

public enum ContentType {
    case Json
    case UrlEncoded
    case MultipartFormData
    case Custom(String)

    func stringValue() -> String {
        switch self {
        case Json:
            return "application/json"
        case UrlEncoded:
            return "application/x-www-form-urlencoded"
        case MultipartFormData:
            return "multipart/form-data"
        case Custom(let value):
            return value
        }
    }
}
