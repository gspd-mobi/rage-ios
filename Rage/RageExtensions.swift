import Foundation

extension NSURLSession {

    func syncTask(request: NSURLRequest) -> (NSData?, NSURLResponse?, NSError?) {
        var data: NSData?, response: NSURLResponse?, error: NSError?

        let semaphore = dispatch_semaphore_create(0)

        dataTaskWithRequest(request) {
            data = $0; response = $1; error = $2
            dispatch_semaphore_signal(semaphore)
        }.resume()

        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)

        return (data, response, error)
    }

}

extension NSData {

    func prettyJson() -> String? {
        do {
            let jsonData = try NSJSONSerialization
            .JSONObjectWithData(self, options: NSJSONReadingOptions())
            let data = try NSJSONSerialization.dataWithJSONObject(jsonData, options: .PrettyPrinted)
            let string = String(data: data, encoding: NSUTF8StringEncoding)
            return string
        } catch {
            return ""
        }
    }

}

extension NSCharacterSet {

    class func URLQueryParameterAllowedCharacterSet() -> Self {
        return self.init(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~/?")
    }

}

extension String {

    func urlEncoded() -> String {
        guard let encodedString = self.stringByAddingPercentEncodingWithAllowedCharacters(
                .URLQueryParameterAllowedCharacterSet()) else {
            preconditionFailure("Error while encoding string \"\(self)\"")
        }
        return encodedString
    }

}
