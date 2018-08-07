import Foundation

public class ParamsBuilder {

    public func stringFromFieldParameters(_ fieldParameters: [String: Parameter]) -> String {
        var fieldsString = ""
        for (key, parameter) in fieldParameters {
            if !fieldsString.isEmpty {
                fieldsString += "&"
            }
            fieldsString += parameter.string(key: key)
        }
        return fieldsString
    }

}
