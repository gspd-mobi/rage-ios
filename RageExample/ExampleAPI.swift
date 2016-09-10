import Foundation
import RxSwift
import Rage

class MyAuthenticator: Authenticator {
    func authorizeRequest(request: RageRequest) -> RageRequest {
        return request.header("Authorization", "Bearer token123")
    }
}

class ExampleAPI {

    static let sharedInstance = ExampleAPI()

    let client: RageClient

    init() {
        client = Rage.builderWithBaseUrl("https://api.github.com")
        .withContentType(.Json)
        .withTimeoutMillis(10 * 1000)
        .withHeaderDictionary([
                "Api-Version": "1.1",
                "Platform": "iOS"
        ])
        .withPlugin(LoggingPlugin(logLevel: .Full))
        .withPlugin(ActivityIndicatorPlugin())
        .withAuthenticator(MyAuthenticator())
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

    func multipartRegister() -> Observable<String> {
        return client.post("/register")
        .multipart()
        .part(TypedObject("123".dataUsingEncoding(NSUTF8StringEncoding)!, mimeType: "application/text"), name: "smth1")
        .part(TypedObject("456".dataUsingEncoding(NSUTF8StringEncoding)!, mimeType: "application/text"), name: "smth2")
        .part(TypedObject("{\"smth\":123}".dataUsingEncoding(NSUTF8StringEncoding)!, mimeType: "application/json"), name: "smth3")
        .stub("{}")
        .executeStringObservable()
    }

    func getOrganization() -> Observable<String> {
        return client.get("/orgs/{org}")
        .path("org", "gspd-mobi")
        .executeStringObservable()
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
            .stub(GithubUser(email:"pavel.korolev@gspd.mobi"))
            .executeStringObservable()
    }

    func getUser() -> Observable<GithubUser> {
        return client.get("/users/{user}")
        .path("user", "PavelKorolev")
        .executeObjectObservable()
    }

    func getOrgRepositories() -> Observable<[GithubRepository]> {
        return client.get("/orgs/{org}/repos")
        .path("org", "gspd-mobi")
        .executeObjectObservable()
    }

    func getUserRepositories() -> Observable<[GithubRepository]> {
        return client.get("/users/{user}/repos")
        .path("user", "PavelKorolev")
        .executeObjectObservable()
    }

    func postUser(user: GithubUser) -> Observable<String> {
        return client.post("/users")
        .withBody()
        .bodyJson(user)
        .executeStringObservable()
    }

}
