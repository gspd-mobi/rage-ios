import Foundation

class URLBuilder {

    static let wrongUrlErrorMessage = "Wrong url provided for request"

    func fromRequest(_ rageRequest: RageRequest) -> URL {
        guard let baseUrl = rageRequest.baseUrl else {
            preconditionFailure("Request url must be provided")
        }
        let urlString = buildUrlString(baseUrl,
                path: rageRequest.methodPath,
                queryParameters: rageRequest.queryParameters,
                pathParameters: rageRequest.pathParameters)

        let optionalUrl = URL(string: urlString)
        guard let url = optionalUrl else {
            preconditionFailure(URLBuilder.wrongUrlErrorMessage)
        }
        return url
    }

    func buildUrlString(_ baseUrl: String,
                        path: String?,
                        queryParameters: [String: Parameter],
                        pathParameters: [String: String]) -> String {
        var pathString = path ?? ""

        for (key, value) in pathParameters {
            let placeholderString = "{\(key)}"
            pathString = pathString.replacingOccurrences(
                    of: placeholderString, with: value.urlEncoded())
        }

        let startSeparator: String
        if path?.contains("?") ?? false {
            startSeparator = "&"
        } else {
            startSeparator = "?"
        }

        var queryParametersString = ""
        for (key, param) in queryParameters {
            if !queryParametersString.isEmpty {
                queryParametersString += "&"
            }
            queryParametersString += param.string(key: key)
        }

        if !queryParametersString.isEmpty {
            queryParametersString = startSeparator + queryParametersString
        }

        return baseUrl + pathString + queryParametersString
    }

}
