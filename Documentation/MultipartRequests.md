Multipart Requests
=============================
Request can also be declared to send Multipart data.

## Making multipart request ##
```swift
let client = Rage.builderWithBaseUrl("http://example.com")
    .build()
let multipartRequest = client.post("/method")
    .multipartRequest()
```

## Adding parts ##
Once request become multipart request you can add parts using `part(_:name:)` function where first parameter is `TypedObject`

`TypedObject` is an description of part which contains String `mimeType`, Data `object` and optional String `fileName`

```swift
let someData: Data = createDataSomehow()
let typedObject = TypedObject(someData, mimeType: "application/json")
multipartRequest.part(typedObject, name: "SomeJsonDataPart")
```

## Custom boundary ##
Custom boundary of multipart request body can be provided using `withCustomBoundary(_:)` function
```swift
multipartRequest.withCustomBoundary("----rage.custom.boundary.example")
```

## Chaining ##
And of course you can chain these all functions.
```swift
let client = Rage.builderWithBaseUrl("http://example.com")
    .build()
let result: Result<RageResponse, RageError> = client.post("/register")
    .multipartRequest()
    .part(TypedObject(userInfoData, mimeType: "application/json"))
    .part(TypedObject(avatarData, mimeType: "image/png")
    .execute() // Execute async for example. Use any execute / enqueue method available for RageRequest class.
```
