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
        .contentType(.UrlEncoded)
        .field("grant_type", "password")
        .field("username", "user")
        .field("password", "pa$$word")
        .requestString()
    }

    func getOrganization() -> Observable<String> {
        return client.get("/orgs/{org}")
        .path("org", "gspd-mobi")
        .requestString()
    }

    func getSomethingError() -> Observable<String> {
        return client.get("/orgs/{org}")
        .path("org", "gsasdasdasdasdas")
        .requestString()
    }

    func getSomething() -> Observable<String> {
        return client.get("/users")
        .queryDictionary(["a": "b", "c": "d"])
        .requestString()
    }

    func getUser() -> Observable<GithubUser> {
        return client.get("/users/{user}")
        .path("user", "PavelKorolev")
        .requestJson()
    }

    func getOrgRepositories() -> Observable<[GithubRepository]> {
        return client.get("/orgs/{org}/repos")
        .path("org", "gspd-mobi")
        .requestJson()
    }

    func getUserRepositories() -> Observable<[GithubRepository]> {
        return client.get("/users/{user}/repos")
        .path("user", "PavelKorolev")
        .requestJson()
    }

    func postUser(user: GithubUser) -> Observable<String> {
        return client.post("/users")
        .bodyJson(user)
        .requestString()
    }

}
