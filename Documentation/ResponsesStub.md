Responses Stub
=============================
In Rage there is way to set stub for request - an object which should be returned as response without actual network call.

## We have request ##
```swift
let client = Rage.builderWithBaseUrl("http://example.com")
    .build()
let request = client.get("/method")
```
## Stub Mode ##
- immediate
- delayed(millis: Int)
- never

## Data as stub ##
```swift
let data: Data = createDataSomehow()
request.stub(data, mode: .immediate)
```

## String as stub ##
```swift
request.stub("String Stub", mode: .immediate)
```
