import Foundation
import RxSwift
import Rage
import Result

class GithubAPI {

    static let timeoutSeconds = 5.0
    static let sharedInstance = GithubAPI()

    let client: RageClient

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = GithubAPI.timeoutSeconds
        configuration.timeoutIntervalForResource = GithubAPI.timeoutSeconds
        let sessionProvider = SessionProvider(configuration: configuration)
        client = Rage.builderWithBaseUrl("https://api.github.com")
            .withSessionProvider(sessionProvider)
            .withContentType(.json)
            .withPlugin(LoggingPlugin(logLevel: .full))
            .withPlugin(ActivityIndicatorPlugin())
            .build()
    }

    func getOrgRepositories(org: String) -> Observable<[GithubRepository]> {
        return client.get("/orgs/{org}/repos")
            .path("org", org)
            .executeObjectObservable()
    }

    func getContributors(repo: String, org: String) -> Observable<[GithubUser]> {
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
