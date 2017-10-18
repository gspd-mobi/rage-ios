import Foundation
import Genome
import Result

extension BodyRageRequest {

    public func bodyJson<T: BasicMappable>(_ value: T) -> BodyRageRequest {
        if !httpMethod.hasBody() {
            preconditionFailure(BodyRageRequest.wrongHttpMethodForBodyErrorMessage)
        }

        guard let data = try? Data(node: value) else {
            return self
        }
        _ = contentType(.json)

        return bodyData(data)
    }

    public func bodyJson<T: BasicMappable>(_ value: [T]) -> BodyRageRequest {
        if !httpMethod.hasBody() {
            preconditionFailure(BodyRageRequest.wrongHttpMethodForBodyErrorMessage)
        }

        guard let data = try? Data(node: value) else {
            return self
        }
        _ = contentType(.json)

        return bodyData(data)
    }

}

extension RageRequest {

    public func stub<T: BasicMappable>(_ value: T, mode: StubMode = .immediate) -> RageRequest {
        guard let data = try? Data.init(node: value) else {
            return self
        }
        return self.stub(data, mode: mode)
    }

    public func stub<T: BasicMappable>(_ value: [T], mode: StubMode = .immediate) -> RageRequest {
        guard let data = try? Data.init(node: value) else {
            return self
        }
        return self.stub(data, mode: mode)
    }

    open func executeObject<T: BasicMappable>() -> Result<T, RageError> {
        let result = self.execute()

        switch result {
        case .success(let response):
            let parsedObject: T? = response.data?.parseBasicMappableJson()
            if let resultObject = parsedObject {
                return .success(resultObject)
            } else {
                return .failure(RageError(type: .configuration,
                        message: RageRequest.jsonParsingErrorMessage))
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    open func executeObject<T: BasicMappable>() -> Result<[T], RageError> {
        let result = self.execute()

        switch result {
        case .success(let response):
            let parsedObject: [T]? = response.data?.parseBasicMappableJsonArray()
            if let resultObject = parsedObject {
                return .success(resultObject)
            } else {
                return .failure(RageError(type: .configuration,
                        message: RageRequest.jsonParsingErrorMessage))
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    open func enqueueObject<T: BasicMappable>(_ completion: @escaping (Result<T, RageError>) -> Void) {
        DispatchQueue.global(qos: .background).async(execute: {
            let result: Result<T, RageError> = self.executeObject()

            DispatchQueue.main.async(execute: {
                completion(result)
            })
        })
    }

    open func enqueueObject<T: BasicMappable>(_ completion: @escaping (Result<[T], RageError>) -> Void) {
        DispatchQueue.global(qos: .background).async(execute: {
            let result: Result<[T], RageError> = self.executeObject()

            DispatchQueue.main.async(execute: {
                completion(result)
            })
        })
    }

}

extension Data {

    func parseBasicMappableJson<T: BasicMappable>() -> T? {
        guard let b = try? T.init(node: self) else {
            return nil
        }
        return b
    }

    func parseBasicMappableJsonArray<T: BasicMappable>() -> [T]? {
        guard let b = try? [T].init(node: self) else {
            return nil
        }
        return b
    }

}

extension BasicMappable {

    public func makeTypedObject() -> TypedObject? {
        guard let data = try? Data.init(node: self) else {
            return nil
        }
        return TypedObject(data, mimeType: ContentType.json.stringValue())
    }

}

extension Array where Element: BasicMappable {

    public func makeTypedObject() -> TypedObject? {
        guard let data = try? Data.init(node: self) else {
            return nil
        }
        return TypedObject(data, mimeType: ContentType.json.stringValue())
    }

}
