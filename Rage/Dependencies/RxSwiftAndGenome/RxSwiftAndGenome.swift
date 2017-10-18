import Foundation
import RxSwift
import Genome

extension RageRequest {

    public func executeObjectObservable<T: BasicMappable>() -> Observable<T> {
        return Observable<T>.create { subscriber in
            let result = self.execute()

            switch result {
            case .success(let response):
                let parsedObject: T? = response.data?.parseBasicMappableJson()
                if let resultObject = parsedObject {
                    subscriber.onNext(resultObject)
                    subscriber.onCompleted()
                } else {
                    subscriber.onError(RageError(type: .configuration,
                            message: RageRequest.jsonParsingErrorMessage))
                }
                break
            case .failure(let error):
                subscriber.onError(error)
                break
            }

            return Disposables.create()
        }
    }

    public func executeObjectObservable<T: BasicMappable>() -> Observable<[T]> {
        return Observable<[T]>.create { subscriber in
            let result = self.execute()

            switch result {
            case .success(let response):
                let parsedObject: [T]? = response.data?.parseBasicMappableJsonArray()
                if let resultObject = parsedObject {
                    subscriber.onNext(resultObject)
                    subscriber.onCompleted()
                } else {
                    subscriber.onError(RageError(type: .configuration,
                            message: RageRequest.jsonParsingErrorMessage))
                }
                break
            case .failure(let error):
                subscriber.onError(error)
                break
            }
            return Disposables.create()
        }
    }

}
