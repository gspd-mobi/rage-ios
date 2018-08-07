Url Encoded Requests
=============================
Request can also be declared to send Form Url Encoded data.

## Make Url Encoded request ##
```swift
let client = Rage.builderWithBaseUrl("http://example.com")
    .build()
let request = client.post("/method")
    .formUrlEncodedRequest()
```

## Fields ##
Once request become urlEncoded you can provide field-parameters.
```swift
let field1 = FieldParameter("value1")
let field2 = FieldParameter("value 2", encoded = true)
request.field("key1", field1)
    .field("key2", field2)
// or using dictionary
request.fieldDictionary(["key1": field1, "key2": field2])
```

### Example ###
```swift
let client = Rage.builderWithBaseUrl("http://example.com")
    .build()
let request = client.post("/method")
    .formUrlEncodedRequest()
    .field("key1", FieldParameter("value1"))
    .field("key2", FieldParameter("value 2", encoded = true))
    .execute() // Will create request to POST http://example.com/method with body "key1=value1&key2=value%202" of Content-Type "application/x-www-form-urlencoded"
```
