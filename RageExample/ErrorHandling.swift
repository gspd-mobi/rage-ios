import Foundation
import Rage
import ObjectMapper

extension Error {

    func description() -> String {
        guard let rageError = self as? RageError else {
            return ""
        }
        return rageError.description()
    }

}

extension RageError {

    func description() -> String {
        switch self.type {
        case .raw:
            return rageResponse?.error?.localizedDescription ?? ""
        case .emptyNetworkResponse:
            return "Empty network response"
        case .configuration:
            return message ?? ""
        case .http:
            guard let data = rageResponse?.data else {
                return "No data returned"
            }
            let githubError: GithubError? = data.parseJson()
            return githubError?.message ?? ""
        case .networkError:
            return "No internet connection"
        }
    }

}
