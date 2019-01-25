import Foundation

open class SessionProvider {

    public let session: URLSession

    public init(configuration: URLSessionConfiguration? = nil) {
        if let configuration = configuration {
            self.session = URLSession(configuration: configuration)
        } else {
            self.session = URLSession.shared
        }
    }

}
