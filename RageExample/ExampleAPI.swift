import Foundation
import RxSwift
import Rage

class ExampleAPI {

    static let sharedInstance = ExampleAPI()

    let client: RageClient

    init() {
        client = Rage.builder()
        .withBaseUrl("https://api.github.com")
        .withLogLevel(.Full)
        .withTimeoutMillis(10 * 1000)
        .build()
    }

    func getOrganization() -> Observable<String> {
        return client.get("/orgs/{org}")
        .path("org", "gspd-mobi")
        .requestString()
    }

    func getUser() -> Observable<GithubUser> {
        return client.get("/users/{user}")
        .path("user", "PavelKorolev")
        .requestJson()
    }
    
}
