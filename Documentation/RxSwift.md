RxSwift
=============================
Use RxSwift subspec of Rage
```ruby
pod "Rage/RxSwift", "~> 0.17.0"
```
Then you can use Rage RxSwift features.

## Execution with Observables ##
```swift
let userStringObservable: Observable<String, RageError> = request.executeStringObservable()
let userDataObservable: Observable<Data, RageError> = request.executeDataObservable()
let userObjectObservable: Observable<User> = request.executeObjectObservable() // Where `User` is `Codable`
let usersArrayObservable: Observable<[User]> = request.executeArrayObservable() // Where `User` is `Codable`
```
