import Foundation
import Rage
import RxSwift
import ObjectMapper

extension RageRequest {

    public func executeObjectObservable<T: Mappable>() -> Observable<T> {
        return taskObservable()
            .flatMap { result -> Observable<T> in
                switch result {
                case .success(let response):
                    let parsedObject: T? = response.data?.parseJson()
                    if let resultObject = parsedObject {
                        return Observable.just(resultObject)
                    } else {
                        return Observable.error(RageError(type: .configuration,
                                                          message: "Couldn't parse object from JSON"))
                    }
                case .failure(let error):
                    return Observable.error(error)
                }
            }
    }

    public func executeObjectObservable<T: Mappable>() -> Observable<[T]> {
        return taskObservable()
            .flatMap { result -> Observable<[T]> in
                switch result {
                case .success(let response):
                    let parsedObject: [T]? = response.data?.parseJsonArray()
                    if let resultObject = parsedObject {
                        return Observable.just(resultObject)
                    } else {
                        return Observable.error(RageError(type: .configuration,
                                                          message: "Couldn't parse object from JSON"))
                    }
                case .failure(let error):
                    return Observable.error(error)
                }
        }
    }

}
