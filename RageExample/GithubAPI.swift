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
        client = Rage.builderWithBaseUrl("https://api.github.com")
            .withSessionProvider(SessionProvider(configuration: configuration))
            .withContentType(.json)
            .withPlugin(LoggingPlugin(logLevel: .full))
            .withPlugin(ActivityIndicatorPlugin())
            .build()
    }

    func getOrgRepositories(org: String) -> Observable<[GithubRepository]> {
        return client.get("/orgs/{org}/repos")
            .request()
            .path("org", org)
            .executeObjectObservable()
    }

    func getContributors(repo: String, org: String) -> Observable<[GithubUser]> {
        return client.get("/repos/{owner}/{repo}/contributors")
            .request()
            .path("owner", org)
            .path("repo", repo)
            .executeObjectObservable()
    }

    func getOrgInfo(org: String) -> Observable<GithubOrganization> {
        return client.get("/orgs/{org}")
            .request()
            .path("org", org)
            .executeObjectObservable()
    }

}
