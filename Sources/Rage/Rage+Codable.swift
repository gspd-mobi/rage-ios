import Foundation

extension Encodable {

    public func encode(encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }

    public func toJSONString(encoder: JSONEncoder = JSONEncoder()) throws -> String? {
        return try String(data: self.encode(encoder: encoder), encoding: .utf8)
    }

    public func makeTypedObject(encoder: JSONEncoder = JSONEncoder()) throws -> TypedObject? {
        guard let json = try toJSONString(encoder: encoder) else {
            return nil
        }
        guard let data = json.utf8Data() else {
            return nil
        }
        return TypedObject(data, mimeType: ContentType.json.stringValue())
    }

}

extension Array where Element: Encodable {

    public func encode(encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }

    public func toJSONString(encoder: JSONEncoder = JSONEncoder()) throws -> String? {
        return try String(data: self.encode(encoder: encoder), encoding: .utf8)
    }

    public func makeTypedObject(encoder: JSONEncoder = JSONEncoder()) throws -> TypedObject? {
        guard let json = try toJSONString(encoder: encoder) else {
            return nil
        }
        guard let data = json.utf8Data() else {
            return nil
        }
        return TypedObject(data, mimeType: ContentType.json.stringValue())
    }

}

extension BodyRageRequest {

    public func bodyJson<T: Codable>(_ value: T, encoder: JSONEncoder = JSONEncoder()) -> BodyRageRequest {
        if !httpMethod.hasBody() {
            preconditionFailure("Can't add body to request with such HttpMethod")
        }

        guard let json = try? value.toJSONString(encoder: encoder) else {
                return self
        }

        _ = contentType(.json)
        return bodyString(json)
    }

    public func bodyJson<T: Codable>(_ value: [T], encoder: JSONEncoder = JSONEncoder()) -> BodyRageRequest {
        if !httpMethod.hasBody() {
            preconditionFailure("Can't add body to request with such HttpMethod")
        }

        guard let json = try? value.toJSONString(encoder: encoder) else {
                return self
        }

        _ = contentType(.json)
        return bodyString(json)
    }

}

extension RageRequest {

    public func stub<T: Codable>(_ value: T,
                                 mode: StubMode = .immediate,
                                 encoder: JSONEncoder = JSONEncoder()) -> RageRequest {
        guard let json = try? value.toJSONString(encoder: encoder) else {
                return self
        }

        return self.stub(json, mode: mode)
    }

    public func stub<T: Codable>(_ value: [T],
                                 mode: StubMode = .immediate,
                                 encoder: JSONEncoder = JSONEncoder()) -> RageRequest {
        guard let json = try? value.toJSONString(encoder: encoder) else {
                return self
        }

        return self.stub(json, mode: mode)
    }

    open func executeObject<T: Codable>(decoder: JSONDecoder = JSONDecoder()) -> Result<T, RageError> {
        let result = self.execute()

        switch result {
        case .success(let response):
            let parsedObject: T? = response.data?.parseJson(decoder: decoder)
            if let resultObject = parsedObject {
                return .success(resultObject)
            } else {
                return .failure(RageError(type: .configuration))
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    open func executeArray<T: Codable>(decoder: JSONDecoder = JSONDecoder()) -> Result<[T], RageError> {
        let result = self.execute()

        switch result {
        case .success(let response):
            let parsedObject: [T]? = response.data?.parseJsonArray(decoder: decoder)
            if let resultObject = parsedObject {
                return .success(resultObject)
            } else {
                return .failure(RageError(type: .configuration))
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    open func enqueueObject<T: Codable>(decoder: JSONDecoder = JSONDecoder(),
                                        _ completion: @escaping (Result<T, RageError>) -> Void) {
        DispatchQueue.global(qos: .background).async(execute: {
            let result: Result<T, RageError> = self.executeObject(decoder: decoder)
            DispatchQueue.main.async(execute: {
                completion(result)
            })
        })
    }

    open func enqueueArray<T: Codable>(decoder: JSONDecoder = JSONDecoder(),
                                       _ completion: @escaping (Result<[T], RageError>) -> Void) {
        DispatchQueue.global(qos: .background).async(execute: {
            let result: Result<[T], RageError> = self.executeArray(decoder: decoder)
            DispatchQueue.main.async(execute: {
                completion(result)
            })
        })
    }

}

extension Data {

    public func parseJson<T: Codable>(decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let value = try? decoder.decode(T.self, from: self) else {
            return nil
        }
        return value
    }

    public func parseJsonArray<T: Codable>(decoder: JSONDecoder = JSONDecoder()) -> [T]? {
        guard let value = try? decoder.decode([T].self, from: self) else {
            return nil
        }
        return value
    }

}
