import Foundation

public class RequestDescription {
    var httpMethod: HttpMethod
    var baseUrl: String
    var path: String?
    var headers: [String:String]
    var contentType: ContentType

    init(httpMethod: HttpMethod, baseUrl: String, contentType: ContentType,
         path: String?, headers: [String:String]) {
        self.httpMethod = httpMethod
        self.baseUrl = baseUrl
        self.path = path
        self.headers = headers
        self.contentType = contentType
    }
}
