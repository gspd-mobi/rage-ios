import Foundation

public class ParamsBuilder {

    func stringFromFieldParameters(_ fieldParameters: [String: FieldParameter]) -> String {
        var fieldsString = ""
        for (key, value) in fieldParameters {
            if !fieldsString.isEmpty {
                fieldsString += "&"
            }
            fieldsString += "\(key)=\(value.valueWithEncodingIfNeeded())"
        }
        return fieldsString
    }

}
