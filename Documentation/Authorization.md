Authorization
=============================
You can authorize requests using `Authenticators`

Authenticator protocol is simple, here is only one function you need to implement - `authorizeRequest(_:)`. This function literally means "What to do with request to authorize it?".

```swift
func authorizeRequest(request: RageRequest) -> RageRequest
```

Authenticator can be provided client wide and request wide. Provided in client building process it will be used in all requests created with this client. If it's provided to request then client wide authenticator will be overridden and this authenticator will be used only in this request.

If you want to make request authorized you must call `authorized()` function for request you're building.

## Example ##
```swift
class MyAuthenticator: Authenticator {

    func authorizeRequest(request: RageRequest) -> RageRequest {
        return request.header("Authorization", "Bearer tokenstring") // Adding header Authorization to our request and return it.
    }

}

func doRequestWithClientAuth() {
    let client = Rage.builderWithBaseUrl("http://example.com")
        .withAuthenticator(MyAuthenticator()) // Providing Authenticator to client while building.
        .build()
    let result = client.get("/method")
        .request()
        .authorized()
        .execute()
}

func doRequestWithRequestAuth() {
     let client = Rage.builderWithBaseUrl("http://example.com")
        .build() // There is no client wide authenticator
     let resultError = client.get("/method")
        .request()
        .authorized() // Error here because there is no authenticator.
        .execute()
     let resultOk = client.get("/method")
        .request()
        .authorized(MyAuthenticator()) // Everything is ok. authorizeRequest function will be applied to this request.
        .execute()
}

```
