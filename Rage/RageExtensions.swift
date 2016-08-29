import Foundation

extension NSURLSession {

    func synchronousDataTaskWithURL(httpMethod: HttpMethod,
                                    url: NSURL,
                                    headers: [String:String],
                                    bodyData: NSData?)
                    -> (NSData?, NSURLResponse?, NSError?) {
        var data: NSData?, response: NSURLResponse?, error: NSError?

        let semaphore = dispatch_semaphore_create(0)

        let request = NSMutableURLRequest(URL: url)
        headers.forEach {
            (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.HTTPMethod = httpMethod.stringValue()
        if httpMethod.hasBody() {
            request.HTTPBody = bodyData
        }

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

extension String {

    func urlEncoded() -> String {
        guard let encodedString = self.stringByAddingPercentEncodingWithAllowedCharacters(
        .URLHostAllowedCharacterSet()) else {
            preconditionFailure("Error while encoding string \"\(self)\"")
        }
        return encodedString
    }

}
