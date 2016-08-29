import Foundation
import Rage
import ObjectMapper

extension ErrorType {

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
        case .Raw:
            return rageResponse?.error?.localizedDescription ?? ""
        case .EmptyNetworkResponse:
            return "Empty network response"
        case .Configuration:
            return message ?? ""
        case .Http:
            guard let data = rageResponse?.data else {
                return "No data returned"
            }
            let githubError: GithubError? = data.parseJson()
            return githubError?.message ?? ""
        case .NetworkError:
            return "No internet connection"
        }
    }

}

extension NSData {

    func parseJson<T: Mappable>() -> T? {
        let resultString = String(data: self, encoding: NSUTF8StringEncoding)!
        guard let b = Mapper<T>().map(resultString) else {
            return nil
        }
        return b
    }

}
