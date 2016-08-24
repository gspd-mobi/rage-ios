import Foundation
import RxSwift

extension RageRequest {

    public func requestString() -> Observable<String> {
        return Observable<String>.create {
            subscriber in
            let (data, _, error) = self.syncCall()
            if let error = error {
                subscriber.onError(RageError(error.localizedDescription))
            } else {
                guard let data = data else {
                    subscriber.onError(RageError(self.emptyResponseErrorMessage))
                    return NopDisposable.instance
                }

                let resultString = String(data: data, encoding: NSUTF8StringEncoding)!
                subscriber.onNext(resultString)
                subscriber.onCompleted()
            }

            return NopDisposable.instance
        }
    }

    public func requestData() -> Observable<NSData> {
        return Observable<NSData>.create {
            subscriber in
            let (data, _, error) = self.syncCall()
            if let error = error {
                subscriber.onError(RageError(error.localizedDescription))
            } else {
                guard let data = data else {
                    subscriber.onError(RageError(self.emptyResponseErrorMessage))
                    return NopDisposable.instance
                }

                subscriber.onNext(data)
                subscriber.onCompleted()
            }

            return NopDisposable.instance
        }
    }

}
