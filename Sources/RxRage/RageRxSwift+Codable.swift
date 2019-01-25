import Foundation
import Rage
import RxSwift

extension RageRequest {

    public func executeObjectObservable<T: Codable>(decoder: JSONDecoder = JSONDecoder()) -> Observable<T> {
        return taskObservable()
            .flatMap { result -> Observable<T> in
                switch result {
                case .success(let response):
                    let parsedObject: T? = response.data?.parseJson(decoder: decoder)
                    if let resultObject = parsedObject {
                        return Observable.just(resultObject)
                    } else {
                        return Observable.error(RageError(type: .configuration))
                    }
                case .failure(let error):
                    return Observable.error(error)
                }
        }
    }

    public func executeArrayObservable<T: Codable>(decoder: JSONDecoder = JSONDecoder()) -> Observable<[T]> {
        return taskObservable()
            .flatMap { result -> Observable<[T]> in
                switch result {
                case .success(let response):
                    let parsedObject: [T]? = response.data?.parseJsonArray(decoder: decoder)
                    if let resultObject = parsedObject {
                        return Observable.just(resultObject)
                    } else {
                        return Observable.error(RageError(type: .configuration))
                    }
                case .failure(let error):
                    return Observable.error(error)
                }
        }
    }

}
