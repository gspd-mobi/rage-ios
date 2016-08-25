import Foundation
import RxSwift

extension RageRequest {

    public func requestString() -> Observable<String> {
        return Observable<String>.create {
            subscriber in
            let response = self.syncCall()
            if response.isSuccess() {
                guard let data = response.data else {
                    subscriber.onError(RageError(self.emptyResponseErrorMessage))
                    return NopDisposable.instance
                }

                let resultString = String(data: data, encoding: NSUTF8StringEncoding)!
                subscriber.onNext(resultString)
                subscriber.onCompleted()
            } else {
                subscriber.onError(RageError(response))
            }

            return NopDisposable.instance
        }
    }

    public func requestData() -> Observable<NSData> {
        return Observable<NSData>.create {
            subscriber in
            let response = self.syncCall()
            if response.isSuccess() {
                guard let data = response.data else {
                    subscriber.onError(RageError(self.emptyResponseErrorMessage))
                    return NopDisposable.instance
                }

                subscriber.onNext(data)
                subscriber.onCompleted()
            } else {
                subscriber.onError(RageError(response))
            }

            return NopDisposable.instance
        }
    }

}
