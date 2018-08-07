import Foundation

public class ParamsBuilder {

    public func stringFromFieldParameters(_ fieldParameters: [String: Parameter]) -> String {
        var fieldsString = ""
        for (key, parameter) in fieldParameters {
            if !fieldsString.isEmpty {
                fieldsString += "&"
            }
            if let value = parameter.valueWithEncodingIfNeeded() {
                fieldsString += "\(key)=\(value)"
            } else {
                fieldsString += key
            }
        }
        return fieldsString
    }

}
