import Foundation
import RxSwift
import ObjectMapper

extension RageRequest {

    public func requestJson<T: Mappable>() -> Observable<T> {
        return Observable<T>.create {
            subscriber in
            let result = self.syncResult()

            switch result {
            case .Success(let response):
                let parsedObject: T? = response.data?.parseJson()
                if let resultObject = parsedObject {
                    subscriber.onNext(resultObject)
                    subscriber.onCompleted()
                } else {
                    subscriber.onError(RageError(type: .Configuration,
                            message: self.jsonParsingErrorMessage))
                }
                break
            case .Failure(let error):
                subscriber.onError(error)
                break
            }

            return NopDisposable.instance
        }
    }

    public func requestJson<T: Mappable>() -> Observable<[T]> {
        return Observable<[T]>.create {
            subscriber in
            let result = self.syncResult()

            switch result {
            case .Success(let response):
                let parsedObject: [T]? = response.data?.parseJsonArray()
                if let resultObject = parsedObject {
                    subscriber.onNext(resultObject)
                    subscriber.onCompleted()
                } else {
                    subscriber.onError(RageError(type: .Configuration,
                            message: self.jsonParsingErrorMessage))
                }
                break
            case .Failure(let error):
                subscriber.onError(error)
                break
            }
            return NopDisposable.instance
        }
    }

}
