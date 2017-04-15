import Foundation
import RxSwift

extension RageRequest {

    public func executeResponseObservable() -> Observable<RageResponse> {
        return Observable<RageResponse>.create { subscriber in
            let result = self.execute()

            switch result {
            case .success(let response):
                subscriber.onNext(response)
                subscriber.onCompleted()
                break
            case .failure(let error):
                subscriber.onError(error)
                break
            }

            return Disposables.create()
        }
    }

    public func executeStringObservable() -> Observable<String> {
        return Observable<String>.create { subscriber in

            let result = self.execute()

            switch result {
            case .success(let response):
                guard let data = response.data else {
                    subscriber.onError(RageError(type: RageErrorType.emptyNetworkResponse))
                    return Disposables.create()
                }

                let resultString = String(data: data, encoding: String.Encoding.utf8)!
                subscriber.onNext(resultString)
                subscriber.onCompleted()
                break
            case .failure(let error):
                subscriber.onError(error)
                break
            }

            return Disposables.create()
        }
    }

    public func executeDataObservable() -> Observable<Data> {
        return Observable<Data>.create { subscriber in
            let result = self.execute()

            switch result {
            case .success(let response):
                guard let data = response.data else {
                    subscriber.onError(RageError(type: RageErrorType.emptyNetworkResponse))
                    return Disposables.create()
                }
                subscriber.onNext(data)
                subscriber.onCompleted()
                break
            case .failure(let error):
                subscriber.onError(error)
                break
            }

            return Disposables.create()
        }
    }

}
