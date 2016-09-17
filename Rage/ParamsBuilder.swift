import Foundation

public class ParamsBuilder {

    func stringFromFieldParameters(fieldParameters: [String:FieldParameter]) -> String {
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
