import Foundation
import RxSwift
import Rage
import Result

var token = "token1"

class MyAuthenticator: Authenticator {

    func authorizeRequest(_ request: RageRequest) -> RageRequest {
        return request.header("Authorization", "Bearer \(token)")
    }

}

class AuthErrorHandler: ErrorHandler {

    override func canHandleError(_ error: RageError) -> Bool {
        return error.statusCode() == 401
    }

    override func handleErrorForRequest(_ request: RageRequest,
                                        result: Result<RageResponse, RageError>)
        -> Result<RageResponse, RageError> {
            switch ExampleAPI.sharedInstance.authSync() {
            case .success(let response):
                guard let data = response.data else {
                    break
                }
                token = String(data: data, encoding: String.Encoding.utf8)!
                self.enabled = false
                return request.authorized().execute()
            case .failure(let error):
                // Logout logic / opening login screen or something
                print(error.description())
            }
            return result
    }

}

class ExampleAPI {

    static let timeoutSeconds = 5.0
    static let sharedInstance = ExampleAPI()

    let client: RageClient

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = ExampleAPI.timeoutSeconds
        configuration.timeoutIntervalForResource = ExampleAPI.timeoutSeconds
        let sessionProvider = SessionProvider(configuration: configuration)
        client = Rage.builderWithBaseUrl("https://api.github.com")
            .withSessionProvider(sessionProvider)
            .withContentType(.json)
            .withHeaderDictionary([
                "Api-Version": "1.1",
                "Platform": "iOS"
                ])
            .withPlugin(LoggingPlugin(logLevel: .full))
            .withPlugin(ActivityIndicatorPlugin())
            .withAuthenticator(MyAuthenticator())
            .withErrorsHandlersClosure {
                [AuthErrorHandler()]
            }
            .build()
    }

    func auth() -> Observable<String> {
        return client.post("/auth")
            .formUrlEncoded()
            .field("grant_type", "password")
            .field("username", "user")
            .field("password", "pa$$word")
            .executeStringObservable()
    }

    func authSync() -> Result<RageResponse, RageError> {
        return client.post("/auth")
            .formUrlEncoded()
            .field("grant_type", "password")
            .field("username", "user")
            .field("password", "pa$$word")
            .stub("token2")
            .execute()
    }

    func multipartRegister() -> Observable<String> {
        let users: [GithubUser] = [GithubUser.init(email: "p.k@gspd.mobi")]
        return client.post("/register")
            .multipart()
            .part(TypedObject("123".data(using: String.Encoding.utf8)!,
                              mimeType: "application/text"), name: "smth1")
            .part(TypedObject("456".data(using: String.Encoding.utf8)!,
                              mimeType: "application/text", fileName: "digits.txt"), name: "smth2")
            .part(TypedObject("{\"smth\":123}".data(using: String.Encoding.utf8)!,
                              mimeType: "application/json"), name: "smth3")
            .part(users.makeTypedObject(), name: "users")
            .stub("{}")
            .executeStringObservable()
    }

    func getOrganization() -> Observable<String> {
        return client.get("/orgs/{org}")
            .authorized()
            .path("org", "gspd-mobi")
            .executeStringObservable()
    }

    func getOrganizationString() -> Result<String, RageError> {
        return client.get("/orgs/{org}")
            .path("org", "gspd-mobi")
            .executeString()
    }

    func getOrgRepositoriesObject(org: String) -> Result<[GithubRepository], RageError> {
        return client.get("/orgs/{org}/repos")
            .path("org", org)
            .executeObject()
    }

    func getOrgRepositoriesAsync(completion:
        @escaping (Result<[GithubRepository], RageError>) -> Void) {
        client.get("/orgs/{org}/repos")
            .path("org", "gspd-mobi")
            .enqueueObject(completion)
    }

    func getSomethingError() -> Observable<String> {
        return client.get("/orgs/{org}")
            .path("org", "gsasdasdasdasdas")
            .executeStringObservable()
    }

    func getSomething() -> Observable<String> {
        return client.get("/users")
            .queryDictionary(["a": "b", "c": "d"])
            .executeStringObservable()
    }

    func getSomethingWithUrlRequest() -> Observable<String> {
        return client.get()
            .url("https://some-other-api-url.com")
            .stub(GithubUser(email: "pavel.korolev@gspd.mobi"))
            .executeStringObservable()
    }

    func getUser() -> Observable<GithubUser> {
        return client.get("/users/{user}")
            .path("user", "PavelKorolev")
            .executeObjectObservable()
    }

    func getOrgRepositories(org: String) -> Observable<[GithubRepository]> {
        return client.get("/orgs/{org}/repos")
            .path("org", org)
            .executeObjectObservable()
    }

    func getUserRepositories() -> Observable<[GithubRepository]> {
        return client.get("/users/{user}/repos")
            .path("user", "PavelKorolev")
            .executeObjectObservable()
    }

    func postUser(_ user: GithubUser) -> Observable<String> {
        return client.post("/users")
            .withBody()
            .bodyJson(user)
            .executeStringObservable()
    }

    func postUsers(_ users: [GithubUser]) -> Observable<String> {
        return client.post("/users")
            .withBody()
            .bodyJson(users)
            .stub(users)
            .executeStringObservable()
    }

    func getContributorsForRepo(_ repo: String, org: String) -> Observable<[GithubUser]> {
        return client.get("/repos/{owner}/{repo}/contributors")
            .path("owner", org)
            .path("repo", repo)
            .executeObjectObservable()
    }

    func getOrgInfo(org: String) -> Observable<GithubOrganization> {
        return client.get("/orgs/{org}")
            .path("org", org)
            .executeObjectObservable()
    }

}
