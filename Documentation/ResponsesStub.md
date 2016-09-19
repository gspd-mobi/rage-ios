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

## NSData as stub ##
```swift
let data: NSData = createDataSomehow()
request.stub(data, mode: .immediate)
```

## String as stub ##
```swift
request.stub("String Stub", mode: .immediate)
```

## String as stub ##
If you use **ObjectMapper* you can set object as stub. It will be serialized to json and will return as response.
```swift
let user = User(name: "Alice") // Where User: Mappable
request.stub(user, mode: .immediate)
```