import Foundation

extension ContentType: Equatable {

}

public func == (lhs: ContentType, rhs: ContentType) -> Bool {
    switch (lhs, rhs) {
    case (.json, .json):
        return true
    case (.urlEncoded, .urlEncoded):
        return true
    case (.multipartFormData, .multipartFormData):
        return true
    case (.custom, .custom):
        return true
    default:
        return false
    }
}
