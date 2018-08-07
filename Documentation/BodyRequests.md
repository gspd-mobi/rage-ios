Body Requests
=============================
There are few ways how data can be specified as body.

## Making request with body ##
```swift
let client = Rage.builderWithBaseUrl("http://example.com")
    .build()
let request = client.post("/method")
    .bodyRequest()
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
