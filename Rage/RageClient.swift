import Foundation

open class RageClient {

    let defaultConfiguration: RageClientConfiguration

    init(defaultConfiguration: RageClientConfiguration) {
        self.defaultConfiguration = defaultConfiguration
    }

    public func get(_ path: String? = nil) -> BasicRequestConfigurator {
        return BasicRequestConfigurator(httpMethod: .get,
                                        path: path,
                                        defaultConfiguration: defaultConfiguration)
    }

    public func post(_ path: String? = nil) -> BasicRequestConfigurator {
        return BasicRequestConfigurator(httpMethod: .post,
                                        path: path,
                                        defaultConfiguration: defaultConfiguration)
    }

    public func put(_ path: String? = nil) -> BasicRequestConfigurator {
        return BasicRequestConfigurator(httpMethod: .put,
                                        path: path,
                                        defaultConfiguration: defaultConfiguration)
    }

    public func delete(_ path: String? = nil) -> BasicRequestConfigurator {
        return BasicRequestConfigurator(httpMethod: .delete,
                                        path: path,
                                        defaultConfiguration: defaultConfiguration)
    }

    public func head(_ path: String? = nil) -> BasicRequestConfigurator {
        return BasicRequestConfigurator(httpMethod: .head,
                                        path: path,
                                        defaultConfiguration: defaultConfiguration)
    }

    public func patch(_ path: String? = nil) -> BasicRequestConfigurator {
        return BasicRequestConfigurator(httpMethod: .patch,
                                        path: path,
                                        defaultConfiguration: defaultConfiguration)
    }

    public func customMethod(_ method: String,
                             path: String? = nil,
                             hasBody: Bool = false) -> BasicRequestConfigurator {
        return BasicRequestConfigurator(httpMethod: .custom(method, hasBody),
                                        path: path,
                                        defaultConfiguration: defaultConfiguration)
    }

}

public class BasicRequestConfigurator {

    let httpMethod: HttpMethod
    let path: String?
    let defaultConfiguration: RageClientConfiguration

    init(httpMethod: HttpMethod,
         path: String? = nil,
         defaultConfiguration: RageClientConfiguration) {
        self.httpMethod = httpMethod
        self.path = path
        self.defaultConfiguration = defaultConfiguration
    }

    public func bodyRequest() -> BodyRageRequest {
        guard httpMethod.hasBody() else {
            fatalError("\(httpMethod.stringValue()) method doesn't support body")
        }
        return BodyRageRequest(requestDescription: requestDescription())
    }

    public func multipartRequest() -> MultipartRageRequest {
        guard httpMethod.hasBody() else {
            fatalError("\(httpMethod.stringValue()) method doesn't support body")
        }
        return MultipartRageRequest(requestDescription: requestDescription())
    }

    public func formUrlEncodedRequest() -> FormUrlEncodedRequest {
        guard httpMethod.hasBody() else {
            fatalError("\(httpMethod.stringValue()) method doesn't support body")
        }
        return FormUrlEncodedRequest(requestDescription: requestDescription())
    }

    public func request() -> RageRequest {
        return RageRequest(requestDescription: requestDescription())
    }

    private func requestDescription() -> RequestDescription {
        let requestDescription = RequestDescription(defaultConfiguration: defaultConfiguration,
                                                    httpMethod: httpMethod,
                                                    path: path)
        let config = self.defaultConfiguration
        requestDescription.authenticator = config.authenticator
        requestDescription.sessionProvider = config.sessionProvider
        requestDescription.plugins = config.plugins
        return requestDescription
    }

}
