Requests Execution
=============================
There are few ways how requests can be executed in Rage.

## We have request ##
```swift
let client = Rage.builderWithBaseUrl("http://example.com")
    .build()
let request = client.get("/method")
```

## Sync execution ##
Using `execute()` functions

```swift
let result: Result<RageResponse, RageError> = request.execute()
let resultString: Result<String, RageError> = request.execute()
let resultData: Result<Data, RageError> = request.execute()
// Handle results
```

## Async execution ##
Using `enqueue(_:)` functions with completion closure.

```swift
request.enqueue {
    (result: Result<RageResponse, RageError>) in
    // Handle result
}

request.enqueueString {
    (result: Result<String, RageError>) in
    // Handle result
}

request.enqueueData {
    (result: Result<Data, RageError>) in
    // Handle result
}
```

## URLRequest ##
If you use Rage only as request building tool and don't want it to execute request inside then you can get `URLRequest` from `RageRequest`
```swift
let rawRequest: URLRequest = request.rawRequest()
// Execute it as you wish
```


## RxSwift wrapped request ##
If you use RxSwift in your project you can create Observable object from request using `execute*Observable` function.

```swift
let dataObservable: Observable<Data> = request.executeDataObservable()
let stringObservable: Observable<String> = request.executeStringObservable()
// Subscribe to observables to execute request.
```
Read more about using **RxSwift** with Rage in **RxSwift** documentation page.