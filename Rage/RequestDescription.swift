import Foundation

public class RequestDescription {
    var httpMethod: HttpMethod
    var baseUrl: String
    var path: String?
    var headers: [String:String]
    var contentType: ContentType

    var authenticator: Authenticator?
    var authorized = false

    init(defaultConfiguration: RageClientDefaultConfiguration,
         httpMethod: HttpMethod,
         path: String?) {
        self.httpMethod = httpMethod
        self.baseUrl = defaultConfiguration.baseUrl
        self.path = path
        self.headers = defaultConfiguration.headers
        self.contentType = defaultConfiguration.contentType
    }
}
