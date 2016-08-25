import Foundation
import RxSwift
import ObjectMapper

extension RageRequest {

    public func requestJson<T: Mappable>() -> Observable<T> {
        return Observable<T>.create {
            subscriber in
            let response = self.syncCall()
            if response.isSuccess() {
                let parsedObject: T? = response.data?.parseJson()
                if let resultObject = parsedObject {
                    subscriber.onNext(resultObject)
                    subscriber.onCompleted()
                } else {
                    subscriber.onError(RageError(self.jsonParsingErrorMessage))
                }
            } else {
                subscriber.onError(RageError(response))
            }

            return NopDisposable.instance
        }
    }

    public func requestJson<T: Mappable>() -> Observable<[T]> {
        return Observable<[T]>.create {
            subscriber in
            let response = self.syncCall()
            if response.isSuccess() {
                let parsedObject: [T]? = response.data?.parseJsonArray()
                if let resultObject = parsedObject {
                    subscriber.onNext(resultObject)
                    subscriber.onCompleted()
                } else {
                    subscriber.onError(RageError(self.jsonParsingErrorMessage))
                }
            } else {
                subscriber.onError(RageError(response))
            }

            return NopDisposable.instance
        }
    }

}
