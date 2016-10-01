import Foundation
import ObjectMapper

extension BodyRageRequest {

    static let wrongHttpMethodForBodyErrorMessage = "Can't add body to request with such HttpMethod"

    public func bodyJson(_ value: Mappable) -> BodyRageRequest {
        if !httpMethod.hasBody() {
            preconditionFailure(BodyRageRequest.wrongHttpMethodForBodyErrorMessage)
        }

        guard let json = value.toJSONString() else {
            return self
        }
        _ = contentType(.json)
        return bodyString(json)
    }

}

extension RageRequest {

    public func stub(_ value: Mappable, mode: StubMode = .immediate) -> RageRequest {
        guard let json = value.toJSONString() else {
            return self
        }
        return self.stub(json, mode: mode)
    }

}

extension Data {

    func parseJson<T: Mappable>() -> T? {
        let resultString = String(data: self, encoding: String.Encoding.utf8)!
        guard let b = Mapper<T>().map(JSONString: resultString) else {
            return nil
        }
        return b
    }

    func parseJsonArray<T: Mappable>() -> [T]? {
        let resultString = String(data: self, encoding: String.Encoding.utf8)!
        guard let b = Mapper<T>().mapArray(JSONString: resultString) else {
            return nil
        }
        return b
    }

}

extension TypedObject {

    class func fromJsonObject(_ object: Mappable) -> TypedObject? {
        guard let json = object.toJSONString() else {
            return nil
        }
        guard let data = json.data(using: String.Encoding.utf8) else {
            return nil
        }
        return TypedObject(data, mimeType: "application/json")
    }

}
