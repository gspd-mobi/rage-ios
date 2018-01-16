Body Requests
=============================
There are few ways how data can be specified as body.

## We have request ##
```swift
let client = Rage.builderWithBaseUrl("http://example.com")
    .build()
let request = client.post("/method")
```

## Body ##
You should call `withBody()` if you want to add body to this request.
```swift
request.withBody()
```

### String as Body ###
```swift
request.body("String Body")
```
You should call `contentType(_)` function for request to specify its Content-Type.

### Data as Body ###
```swift
let data: Data = createDataSomehow()
request.body(data)
```
You should call `contentType(_)` function for request to specify its Content-Type.
