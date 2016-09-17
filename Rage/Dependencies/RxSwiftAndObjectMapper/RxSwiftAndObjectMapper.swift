import Foundation
import RxSwift
import ObjectMapper

extension RageRequest {

    static let jsonParsingErrorMessage = "Couldn't parse object from JSON"
    
    public func executeObjectObservable<T: Mappable>() -> Observable<T> {
        return Observable<T>.create {
            subscriber in
            let result = self.execute()

            switch result {
            case .Success(let response):
                let parsedObject: T? = response.data?.parseJson()
                if let resultObject = parsedObject {
                    subscriber.onNext(resultObject)
                    subscriber.onCompleted()
                } else {
                    subscriber.onError(RageError(type: .Configuration,
                            message: RageRequest.jsonParsingErrorMessage))
                }
                break
            case .Failure(let error):
                subscriber.onError(error)
                break
            }

            return NopDisposable.instance
        }
    }

    public func executeObjectObservable<T: Mappable>() -> Observable<[T]> {
        return Observable<[T]>.create {
            subscriber in
            let result = self.execute()

            switch result {
            case .Success(let response):
                let parsedObject: [T]? = response.data?.parseJsonArray()
                if let resultObject = parsedObject {
                    subscriber.onNext(resultObject)
                    subscriber.onCompleted()
                } else {
                    subscriber.onError(RageError(type: .Configuration,
                            message: RageRequest.jsonParsingErrorMessage))
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
