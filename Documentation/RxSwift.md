RxSwift
=============================
Install RxSwift using CocoaPods.
```ruby
pod 'RxSwift', '~> 3.0.0-beta.2'
```
Then you can use Rage RxSwift features.

## Execution with Observables ##
```swift
let userStringObservable: Observable<String, RageError> = request.executeStringObservable()
let userDataObservable: Observable<Data, RageError> = request.executeDataObservable()
```

## With ObjectMapper ##
If both RxSwift and ObjectMapper used you can use `executeObjectObservable()` function to get parsed data as Observable.
```swift
let userObjectObservable: Observable<GithubUser, RageError> = request.executeObjectObservable() // Where GithubUser is Mappable
let usersObjectObservable: Observable<[GithubUser], RageError> = request.executeObjectObservable() // Works for arrays too
```
