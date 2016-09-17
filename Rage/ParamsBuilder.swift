import Foundation

public class ParamsBuilder {

    func buildUrlString(baseUrl: String,
                              path: String?,
                              queryParameters: [String:String],
                              pathParameters: [String:String]) -> String {
        var pathString = path ?? ""

        for (key, value) in pathParameters {
            let placeholderString = "{\(key)}"
            pathString = pathString.stringByReplacingOccurrencesOfString(placeholderString,
                    withString: value.urlEncoded())
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

    func buildUrlEncodedString(fieldParameters: [String:FieldParameter]) -> String {
        var fieldsString = ""
        for (key, value) in fieldParameters {
            if !fieldsString.isEmpty {
                fieldsString += "&"
            }
            var valueString = String(value.value)
            if value.encoded {
                valueString = valueString.urlEncoded()
            }
            fieldsString += "\(key)=\(valueString)"
        }
        return fieldsString
    }

}
