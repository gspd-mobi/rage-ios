import Foundation
import Rage
import RxSwift
import Result

extension RageRequest {

    open func taskObservable() -> Observable<Result<RageResponse, RageError>> {
        return Observable.deferred { () -> Observable<Result<RageResponse, RageError>> in
            return Observable.create { observer in
                self.sendPluginsWillSendRequest()

                let request = self.rawRequest()

                self.sendPluginsDidSendRequest(request)

                if let stub = self.getStubData() {
                    let rageResponse = RageResponse(request: self, data: stub, response: nil, error: nil)
                    self.sendPluginsDidReceiveResponse(rageResponse, rawRequest: request)
                    observer.onNext(.success(rageResponse))
                    return Disposables.create()
                }

                let startDate = Date()
                let task = self.session.dataTask(with: request, completionHandler: { data, response, error in
                    let requestDuration = Date().timeIntervalSince(startDate) * 1000
                    let rageResponse = RageResponse(request: self,
                                                    data: data,
                                                    response: response,
                                                    error: error as NSError?,
                                                    timeMillis: requestDuration)

                    self.sendPluginsDidReceiveResponse(rageResponse, rawRequest: request)

                    if rageResponse.isSuccess() {
                        observer.onNext(.success(rageResponse))
                    } else {
                        let rageError = RageError(response: rageResponse)
                        observer.onNext(.failure(rageError))
                    }
                    observer.onCompleted()
                })

                task.resume()

                return Disposables.create {
                    task.cancel()
                }
            }
        }
    }

    public func executeResponseObservable() -> Observable<RageResponse> {
        return taskObservable()
            .flatMap { result -> Observable<RageResponse> in
                switch result {
                case .success(let response):
                    return Observable.just(response)
                case .failure(let error):
                    return Observable.error(error)
                }
            }
    }

    public func executeStringObservable() -> Observable<String> {
        return taskObservable()
            .flatMap { result -> Observable<String> in
                switch result {
                case .success(let response):
                    guard let data = response.data else {
                        return Observable.error(RageError(type: RageErrorType.emptyNetworkResponse))
                    }

                    let resultString = String(data: data, encoding: String.Encoding.utf8)!
                    return Observable.just(resultString)
                case .failure(let error):
                    return Observable.error(error)
                }
            }
    }

    public func executeDataObservable() -> Observable<Data> {
        return taskObservable()
            .flatMap { result -> Observable<Data> in
                switch result {
                case .success(let response):
                    guard let data = response.data else {
                        return Observable.error(RageError(type: RageErrorType.emptyNetworkResponse))
                    }
                    return Observable.just(data)
                case .failure(let error):
                    return Observable.error(error)
                }
        }
    }

}
