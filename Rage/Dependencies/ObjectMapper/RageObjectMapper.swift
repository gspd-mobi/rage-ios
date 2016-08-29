import Foundation
import ObjectMapper

extension RageRequest {

    public func bodyJson(value: Mappable) -> RageRequest {
        if !httpMethod.hasBody() {
            preconditionFailure(self.wrongHttpMethodForBodyErrorMessage)
        }

        guard let json = value.toJSONString() else {
            return self
        }
        return bodyString(json)
    }

}

extension NSData {

    func parseJson<T: Mappable>() -> T? {
        let resultString = String(data: self, encoding: NSUTF8StringEncoding)!
        guard let b = Mapper<T>().map(resultString) else {
            return nil
        }
        return b
    }

    func parseJsonArray<T: Mappable>() -> [T]? {
        let resultString = String(data: self, encoding: NSUTF8StringEncoding)!
        guard let b = Mapper<T>().mapArray(resultString) else {
            return nil
        }
        return b
    }

}
