Rage for iOS
=============================
[![Travis CI](https://api.travis-ci.org/gspd-mobi/rage-ios.svg?branch=master)](https://travis-ci.org/gspd-mobi/rage-ios)
[![Version](https://img.shields.io/cocoapods/v/Rage.svg?style=flat)](https://cocoapods.org/pods/Rage)
[![License](https://img.shields.io/cocoapods/l/Rage.svg?style=flat)](LICENSE.txt)
[![Platform](https://img.shields.io/cocoapods/p/Rage.svg?style=flat)](https://cocoapods.org/pods/Rage)

<p align="center">
  <img height="340" src="web/img/logo-text.png" />
</p>

Pragmatic network abstraction layer for iOS applications.

## :warning: Warning ##
Library is NOT production ready yet. Please don't use it before it gets more stable.
There may be compatibility issues between newer and older versions of library until version **1.0.0**.

Documentation now may differ from real API because it's unstable and improving pretty fast.

## Features ##
* One liner request making. :dart:
* Describing API spec in highly readable way. :books:
* Out of box JSON support by Codable. :ledger:
* Optional [RxSwift](https://github.com/ReactiveX/RxSwift) out of box. :rocket:
* Manipulating strictly typed objects instead of String dictionaries hell. :package:

## Usage ##
You can check example implementation in RageExample project.

At first you need to create RageClient using builder pattern.
```swift
let client = Rage.builderWithBaseUrl("https://api.github.com")
    .withContentType(.json)
    .withHeaderDictionary([
            "Api-Version": "1.1",
            "Platform": "iOS"
    ])
    .withPlugin(LoggingPlugin(logLevel: .full))
    .withAuthenticator(MyAuthenticator())
    .build()
```
Then describe your API requests like these. It is a generic way to declare requests and their background execution.
```swift
func getUser(username: String, completion: @escaping Result<RageResponse, RageError> -> ()) {
    client.get("/users/{user}")
        .request()
        .path("user", username)
        .enqueue(completion)
}

// Async
func getRepositoriesForOrganization(organizationTitle: String, completion: @escaping Result<RageResponse, RageError> -> ()) {
    client.get("/orgs/{org}/repos")
        .request()
        .path("org", organizationTitle)
        .enqueue(completion)
}

// Sync
func getRepositoriesForOrganizationSync(organizationTitle: String) -> Result<RageResponse, RageError> {
    return client.get("/orgs/{org}/repos")
        .request()
        .path("org", organizationTitle)
        .execute()
}
```

Using **RxSwift**  you can declare API in such awesome way.
```swift
func getUser(username: String) -> Observable<GithubUser> {
    return client.get("/users/{user}")
        .request()
        .path("user", username)
        .executeObjectObservable()
}

func getRepositoriesForOrganization(organizationTitle: String) -> Observable<[GithubRepository]> {
    return client.get("/orgs/{org}/repos")
        .request()
        .path("org", organizationTitle)
        .executeArrayObservable()
}
```
That's it. Compact but powerful.

## Installation (CocoaPods) ##
Add this dependency to Podfile and `pod install`
```ruby
# Core subspec of Rage
pod 'Rage', '~> 0.17.1'
```
Or if you want to use RxSwift features you should use these Rage subspec
```ruby
# RxSwift only
pod "Rage/RxSwift", "~> 0.17.1"
```

License
-------
    The MIT License (MIT)

    Copyright (c) 2016-2018 gspd.mobi

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
