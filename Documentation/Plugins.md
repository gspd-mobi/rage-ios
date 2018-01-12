Plugins
=============================
There is `RagePlugin` protocol which can be used to create own plugins for Rage.
```swift
public protocol RagePlugin {

    func willSendRequest(_ request: RageRequest)
    func didReceiveResponse(_ response: RageResponse, rawRequest: URLRequest)
    func didSendRequest(_ request: RageRequest, rawRequest: URLRequest)

}
```
All functions are optional to implement in own plugins

### Possible usages ###
Plugins can be used to make some changes to request right before sending using `willSendRequest(_ request: RageRequest)` function.
Plugins can be used handle responses using `didReceiveResponse(_ response: RageResponse, rawRequest: URLRequest)` function.
Plugins can be used handle request sent event using `didSendRequest(_ request: RageRequest, rawRequest: URLRequest)` function.

There are two plugins shipped by default with Rage. LoggingPlugin and ActivityIndicatorPlugin.

## Logging Plugin ##
Plugin which logs rage request.

There are 4 log levels
### .none ###
Logs nothing.

### .basic ###
Logs only request method and url when request sent.

### .medium ###
Same as `.basic` plus response body. JSON responses automatically prettified before printing.

### .full ###
Same as `.medium` plus request and response headers.

Usage with RageClient.
```swift
let loggingPlugin = LoggingPlugin(logLevel: .full)
rageClient.withPlugin(loggingPlugin)
```

## Activity Indicator Plugin ##
Plugin which shows iOS activity indicator before request sent and hides it when response received.

```swift
let activityIndicatorPlugin = ActivityIndicatorPlugin()
rageClient.withPlugin(activityIndicatorPlugin)
```
