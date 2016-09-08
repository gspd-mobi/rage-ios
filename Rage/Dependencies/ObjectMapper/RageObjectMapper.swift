import Foundation
import ObjectMapper

extension BodyRageRequest {

    public func bodyJson(value: Mappable) -> BodyRageRequest {
        if !httpMethod.hasBody() {
            preconditionFailure(self.wrongHttpMethodForBodyErrorMessage)
        }

        guard let json = value.toJSONString() else {
            return self
        }
        return bodyString(json)
    }

}

extension RageRequest {

    public func stub(value: Mappable, mode: StubMode = .immediate) -> RageRequest {
        guard let json = value.toJSONString() else {
            return self
        }
        return self.stub(json, mode: mode)
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

extension TypedObject {

    class func fromJsonObject(object: Mappable) -> TypedObject? {
        guard let json = object.toJSONString() else {
            return nil
        }
        guard let data = json.dataUsingEncoding(NSUTF8StringEncoding) else {
            return nil
        }
        return TypedObject(data, mimeType: "application/json")
    }

}
