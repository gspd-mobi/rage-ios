import Foundation

class URLBuilder {

    static let wrongUrlErrorMessage = "Wrong url provided for request"

    func fromRequest(rageRequest: RageRequest) -> NSURL {
        let urlString = buildUrlString(rageRequest.baseUrl,
                path: rageRequest.methodPath,
                queryParameters: rageRequest.queryParameters,
                pathParameters: rageRequest.pathParameters)

        let optionalUrl = NSURL(string: urlString)
        guard let url = optionalUrl else {
            preconditionFailure(URLBuilder.wrongUrlErrorMessage)
        }
        return url
    }

    func buildUrlString(baseUrl: String,
                        path: String?,
                        queryParameters: [String:String],
                        pathParameters: [String:String]) -> String {
        var pathString = path ?? ""

        for (key, value) in pathParameters {
            let placeholderString = "{\(key)}"
            pathString = pathString.stringByReplacingOccurrencesOfString(
                    placeholderString, withString: value.urlEncoded())
        }

        var queryParametersString = ""
        for (key, value) in queryParameters {
            if !queryParametersString.isEmpty {
                queryParametersString += "&"
            }
            queryParametersString += "\(key.urlEncoded())=\(value.urlEncoded())"
        }

        if !queryParametersString.isEmpty {
            queryParametersString = "?" + queryParametersString
        }

        return baseUrl + pathString + queryParametersString
    }

}
