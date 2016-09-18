Requests Customization
=============================
Client provides `baseUrl` to request when creating it. It says is it GET/POST/PUT/any request and what is the relative path of this request.
So basically without additional customization we can create requests like `GET http://example.com/method`.
How do we customize it?

## We have request ##
```swift
let client = Rage.builderWithBaseUrl("http://example.com")
    .build()
let request = client.get("/method")
```

## Query parameters ##
Query parameters appear as string like `key1=value1&key2=value2` written with leading question mark `?` in url request.
`http://example.com/method?key1=value1&key2=value2`
How do we add them?
```swift
request.query("key1","value1")
    .query("key2","value2")
// or using dictionary which is useful when you want to add more than one query parameter
request.queryDictionary(["key1": "value1", "key2":"value2"])
```

## Path parameters ##
Path parameters appear as part of provided url like `http://example.com/method/pathParam/subMethod`.
To make `pathParam` replaceable we surround them with `{` and `}`. So we need to use corresponding url when creating it.
```swift
let request = client.get("/method/{pathParam}/subMethod")
```
How do we add them?
```swift
request.path("pathParam","pathValue")
```

## Headers ##
It's possible when one single request should have some special header.
How do we add headers for requests in Rage?
```swift
request.header("SomeNewHeader", "Some-New-Header-Value-Whatever")
// or using dictionary which is useful when you want to add more than one headers
request.headerDictionary(["SomeNewHeader": "Some-New-Header-Value-Whatever", "Header2": "HeaderValue2"])
```

## URL changing ##
You can change even this single request `baseUrl` if you need it.
```swift
request.url("http://example2.com")
```

## Chaining ##
Most awesome thing is that you can chain all these customizations and create one-liner request specification.
```swift
func doSomething() {
    let client = Rage.builderWithBaseUrl("http://example.com")
        .build()
    let result = client.get("/method")
        .url("http://example2.com/{pathParamName}")
        .query("queryParamName", "queryParamValue")
        .path("pathParamName", "pathParamValue")
        .header("SomeNewHeader", "Some-New-Header-Value-Whatever"
        .execute() // Will create request to "http://example2.com/pathParamValue/method?queryParamName=queryParamValue" with header "SomeNewHeader"
}

```