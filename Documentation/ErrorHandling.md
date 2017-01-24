Error Handling
=============================
There is `ErrorHandler` class which subclasses should be used to create your own handlers for specifying how to handle some error.

```swift
open class ErrorHandler {

    open var enabled: Bool = true

    public init() {
        // No operations.
    }

    open func canHandleError(_ error: RageError) -> Bool {
        return false
    }

    open func handleErrorForRequest(_ request: RageRequest,
                               result: Result<RageResponse, RageError>)
        -> Result<RageResponse, RageError> {
            return result
    }

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

    override func canHandleError(_ error: RageError) -> Bool {
        return error.statusCode() == 401
    }

    override func handleErrorForRequest(_ request: RageRequest,
                               result: Result<RageResponse, RageError>)
                    -> Result<RageResponse, RageError> {
        // Here is very simple example of retrying request once after repeated auth request
        switch ExampleAPI.sharedInstance.authSync() {
        case .success(let response):
            guard let data = response.data else {
                break
            }
            token = String(data: data, encoding: String.Encoding.utf8)!
            self.enabled = false
            return request.authorized().execute()
        case .failure(let error):
            // Logout logic / opening login screen or something
            print(error.description())
            break
        }
        return result
    }

}
```
