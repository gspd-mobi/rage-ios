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

### NSData as Body ###
```swift
let data: NSData = createDataSomehow()
request.body(data)
```
You should call `contentType(_)` function for request to specify its Content-Type.

### JSON object as Body ###
If you use **ObjectMapper** you can provide *Mappable* object to `body()` function. Object will be serialized to JSON string and set to body.
```swift
let user = User(name: "Alice") // Where User: Mappable
request.body(user)
```
Its Content-Type specified as `application/json`.