import Foundation
import Rage
import ObjectMapper
import Result

extension BodyRageRequest {

    public func bodyJson<T: Mappable>(_ value: T) -> BodyRageRequest {
        if !httpMethod.hasBody() {
            preconditionFailure("HttpMethod with body support must be used")
        }

        guard let json = value.toJSONString() else {
            return self
        }
        _ = contentType(.json)
        return bodyString(json)
    }

    public func bodyJson<T: Mappable>(_ value: [T]) -> BodyRageRequest {
        if !httpMethod.hasBody() {
            preconditionFailure("HttpMethod with body support must be used")
        }

        guard let json = value.toJSONString() else {
            return self
        }
        _ = contentType(.json)
        return bodyString(json)
    }

}

extension RageRequest {

    public func stub<T: Mappable>(_ value: T, mode: StubMode = .immediate) -> RageRequest {
        guard let json = value.toJSONString() else {
            return self
        }
        return self.stub(json, mode: mode)
    }

    public func stub<T: Mappable>(_ value: [T], mode: StubMode = .immediate) -> RageRequest {
        guard let json = value.toJSONString() else {
            return self
        }
        return self.stub(json, mode: mode)
    }

    open func executeObject<T: Mappable>() -> Result<T, RageError> {
        let result = self.execute()

        switch result {
        case .success(let response):
            let parsedObject: T? = response.data?.parseJson()
            if let resultObject = parsedObject {
                return .success(resultObject)
            } else {
                return .failure(RageError(type: .configuration,
                                          message: "Couldn't parse object from JSON"))
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    open func executeObject<T: Mappable>() -> Result<[T], RageError> {
        let result = self.execute()

        switch result {
        case .success(let response):
            let parsedObject: [T]? = response.data?.parseJsonArray()
            if let resultObject = parsedObject {
                return .success(resultObject)
            } else {
                return .failure(RageError(type: .configuration,
                                          message: "Couldn't parse object from JSON"))
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    open func enqueueObject<T: Mappable>(_ completion: @escaping (Result<T, RageError>) -> Void) {
        DispatchQueue.global(qos: .background).async(execute: {
            let result: Result<T, RageError> = self.executeObject()

            DispatchQueue.main.async(execute: {
                completion(result)
            })
        })
    }

    open func enqueueObject<T: Mappable>(_ completion: @escaping (Result<[T], RageError>) -> Void) {
        DispatchQueue.global(qos: .background).async(execute: {
            let result: Result<[T], RageError> = self.executeObject()

            DispatchQueue.main.async(execute: {
                completion(result)
            })
        })
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

extension Mappable {

    public func makeTypedObject() -> TypedObject? {
        guard let json = toJSONString() else {
            return nil
        }
        guard let data = json.utf8Data() else {
            return nil
        }
        return TypedObject(data, mimeType: ContentType.json.stringValue())
    }

}

extension Array where Element: Mappable {

    public func makeTypedObject() -> TypedObject? {
        guard let json = toJSONString() else {
            return nil
        }
        guard let data = json.utf8Data() else {
            return nil
        }
        return TypedObject(data, mimeType: ContentType.json.stringValue())
    }

}
