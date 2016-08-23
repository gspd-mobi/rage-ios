import Foundation

public class ParamsBuilder {

    class func buildUrlString(baseUrl: String,
                              path: String,
                              queryParameters: [String:String],
                              pathParameters: [String:String]) -> String {
        var pathString = path

        pathParameters.forEach {
            (key, value) in
            let placeholderString = "{\(key)}"
            pathString = pathString.stringByReplacingOccurrencesOfString(placeholderString,
                withString: value.urlEncoded())
        }

        var queryParametersString = ""
        queryParameters.forEach {
            (key, value) in
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
