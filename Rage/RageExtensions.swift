import Foundation

extension Data {

    public func prettyJsonString() -> String? {
        do {
            let jsonData = try JSONSerialization
                .jsonObject(with: self, options: JSONSerialization.ReadingOptions())
            let data = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
            let string = String(data: data, encoding: String.Encoding.utf8)
            return string
        } catch {
            return nil
        }
    }

    public func utf8String() -> String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }

}

extension CharacterSet {

    public static func URLQueryParameterAllowedCharacterSet() -> CharacterSet {
        let charsString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~/?"
        return self.init(charactersIn: charsString)
    }

}

public extension String {

    public func urlEncoded() -> String {
        guard let encodedString = self.addingPercentEncoding(
                withAllowedCharacters: .URLQueryParameterAllowedCharacterSet()) else {
            preconditionFailure("Error while encoding string \"\(self)\"")
        }
        return encodedString
    }

    public func utf8Data() -> Data? {
        return data(using: String.Encoding.utf8)
    }

}
