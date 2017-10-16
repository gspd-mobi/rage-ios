RxSwift
=============================
Use RxSwift subspec of Rage
```ruby
pod "Rage/RxSwift", "~> 0.10.4"
# If you want to use both RxSwift and ObjectMapper then use RxSwiftAndObjectMapper subspec
# pod "Rage/RxSwiftAndObjectMapper", "~> 0.10.4"
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
