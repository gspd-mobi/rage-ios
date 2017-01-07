import Foundation

extension URLSession {

    func syncTask(with request: URLRequest) -> (Data?, URLResponse?, NSError?) {
        var data: Data?, response: URLResponse?, error: NSError?

        let semaphore = DispatchSemaphore(value: 0)

        dataTask(with: request, completionHandler: {
            data = $0; response = $1; error = $2 as NSError?
            semaphore.signal()
        }) .resume()

        _ = semaphore.wait(timeout: DispatchTime.distantFuture)

        return (data, response, error)
    }

}

extension Data {

    func prettyJsonString() -> String? {
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

    func utf8String() -> String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }

}

extension CharacterSet {

    static func URLQueryParameterAllowedCharacterSet() -> CharacterSet {
        let charsString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~/?"
        return self.init(charactersIn: charsString)
    }

}

extension String {

    func urlEncoded() -> String {
        guard let encodedString = self.addingPercentEncoding(
                withAllowedCharacters: .URLQueryParameterAllowedCharacterSet()) else {
            preconditionFailure("Error while encoding string \"\(self)\"")
        }
        return encodedString
    }

    func utf8Data() -> Data? {
        return data(using: String.Encoding.utf8)
    }

}
