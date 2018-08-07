import Foundation

public class Parameter {
    func string(key: String) -> String {
        return ""
    }
}

public class SingleParameter: Parameter {

    var value: String?
    var encoded: Bool

    public init(value: String?, encoded: Bool = true) {
        self.value = value
        self.encoded = encoded
    }

    public override func string(key: String) -> String {
        if let value = valueWithEncodingIfNeeded() {
            return "\(key)=\(value)"
        }
        return key
    }

    public func valueWithEncodingIfNeeded() -> String? {
        if encoded {
            return value?.urlEncoded()
        }
        return value
    }

}

public class ArrayParameter: Parameter {

    public enum StringMode {
        case commaSeparated
        case repeatKey
        case repeatKeyBrackets
    }

    var values: [String]
    var stringMode: StringMode

    init(values: [String],
         stringMode: StringMode = .repeatKeyBrackets) {
        self.values = values
        self.stringMode = stringMode
    }

    public override func string(key: String) -> String {
        switch stringMode {
        case .commaSeparated:
            return commaSeparatedString(key: key)
        case .repeatKey:
            return repeatKeyString(key: key)
        case .repeatKeyBrackets:
            return repeatKeyBracketsString(key: key)
        }
    }

    private func commaSeparatedString(key: String) -> String {
        var valuesString = ""
        for value in values {
            if !valuesString.isEmpty {
                valuesString += ","
            }
            valuesString += value
        }
        return "\(key)=\(valuesString)"
    }

    private func repeatKeyString(key: String) -> String {
        var valuesString = ""
        for value in values {
            if !valuesString.isEmpty {
                valuesString += "&"
            }
            valuesString += "\(key)=\(value)"
        }
        return valuesString
    }

    private func repeatKeyBracketsString(key: String) -> String {
        var valuesString = ""
        for value in values {
            if !valuesString.isEmpty {
                valuesString += "&"
            }
            valuesString += "\(key)[]=\(value)"
        }
        return valuesString
    }

}
