import Foundation
import RxSwift
import ObjectMapper

extension RageRequest {

    public func requestJson<T: Mappable>() -> Observable<T> {
        return Observable<T>.create {
            subscriber in
            let (data, _, error) = self.syncCall()
            if let error = error {
                subscriber.onError(RageError(error.localizedDescription))
            } else {
                let parsedObject: T? = data?.parseJson()
                if let resultObject = parsedObject {
                    subscriber.onNext(resultObject)
                    subscriber.onCompleted()
                } else {
                    subscriber.onError(RageError(self.jsonParsingErrorMessage))
                }
            }

            return NopDisposable.instance
        }
    }

    public func requestJson<T: Mappable>() -> Observable<[T]> {
        return Observable<[T]>.create {
            subscriber in
            let (data, _, error) = self.syncCall()
            if let error = error {
                subscriber.onError(RageError(error.localizedDescription))
            } else {
                let parsedObject: [T]? = data?.parseJsonArray()
                if let resultObject = parsedObject {
                    subscriber.onNext(resultObject)
                    subscriber.onCompleted()
                } else {
                    subscriber.onError(RageError(self.jsonParsingErrorMessage))
                }
            }

            return NopDisposable.instance
        }
    }

}
