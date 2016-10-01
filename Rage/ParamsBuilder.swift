import Foundation

open class ParamsBuilder {

    func stringFromFieldParameters(_ fieldParameters: [String:FieldParameter]) -> String {
        var fieldsString = ""
        for (key, value) in fieldParameters {
            if !fieldsString.isEmpty {
                fieldsString += "&"
            }
            if let valueString = String(value.value) {
                let resultValueString: String
                if value.encoded {
                    resultValueString = valueString.urlEncoded()
                } else {
                    resultValueString = valueString
                }
                fieldsString += "\(key)=\(resultValueString)"
            }
        }
        return fieldsString
    }

}
