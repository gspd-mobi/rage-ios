import Foundation
import RxSwift

extension RageRequest {

    public func executeStringObservable() -> Observable<String> {
        return Observable<String>.create {
            subscriber in

            let result = self.execute()

            switch result {
            case .Success(let response):
                guard let data = response.data else {
                    subscriber.onError(RageError(type: RageErrorType.EmptyNetworkResponse))
                    return NopDisposable.instance
                }

                let resultString = String(data: data, encoding: NSUTF8StringEncoding)!
                subscriber.onNext(resultString)
                subscriber.onCompleted()
                break
            case .Failure(let error):
                subscriber.onError(error)
                break
            }

            return NopDisposable.instance
        }
    }

    public func executeDataObservable() -> Observable<NSData> {
        return Observable<NSData>.create {
            subscriber in
            let result = self.execute()

            switch result {
            case .Success(let response):
                guard let data = response.data else {
                    subscriber.onError(RageError(type: RageErrorType.EmptyNetworkResponse))
                    return NopDisposable.instance
                }
                subscriber.onNext(data)
                subscriber.onCompleted()
                break
            case .Failure(let error):
                subscriber.onError(error)
                break
            }

            return NopDisposable.instance
        }
    }

}
