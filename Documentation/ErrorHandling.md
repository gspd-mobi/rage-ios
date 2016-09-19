Error Handling
=============================
There is `ErrorHandler` protocol which should be used to create your own handlers for specifying how to handle some error.

```swift
public protocol ErrorHandler {

    var enabled: Bool { get set }

    func canHandleError(error: RageError) -> Bool

    func handleErrorForRequest(request: RageRequest,
                               result: Result<RageResponse, RageError>)
        -> Result<RageResponse, RageError>

}
```
So basically you need to answer two questions: "Which errors to handle?" and "How to handle these errors".

### Some possible usages of `ErrorHandler` ###
- Retry requests on error
- Refresh authorization and retry requests after
- Open login screen if unauthorized
- Save some data to local storage to retry sending later

## How to use ##
Create `ErrorHandler` implementation and add it to errors closure of client building process. It's needed to create error handlers per request.
```swift
client = Rage.builderWithBaseUrl("http://example.com")
    .withErrorsHandlersClosure {
        [AuthErrorHandler()]
    }
    .build()
```

## Example ##
Let's say we need to handle `Unauthorized 401` for any request and do something if it happens.

```swift
class AuthErrorHandler: ErrorHandler {

    var enabled = true

    func canHandleError(error: RageError) -> Bool {
        return error.statusCode() == 401
    }

    func handleErrorForRequest(request: RageRequest,
                               result: Result<RageResponse, RageError>)
                    -> Result<RageResponse, RageError> {
        // Here is very simple example of retrying request once after repeated auth request
        switch ExampleAPI.sharedInstance.authSync() {
        case .Success(let response):
            guard let data = response.data else {
                break
            }
            token = String(data: data, encoding: NSUTF8StringEncoding)!
            self.enabled = false // We disable this handler to avoid infinite loop
            return request.authorized().execute()
        case .Failure(let error):
            // Logout logic / opening login screen or something
            print(error.description())
            break
        }
        return result
    }

}
```