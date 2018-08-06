
<p align="center">
  <img height="160" src="web/logo_github.png" />
</p>

# IORequestable

[![CI Status](https://img.shields.io/travis/royhcj/IORequestable.svg?style=flat)](https://travis-ci.org/royhcj/IORequestable)
[![Version](https://img.shields.io/cocoapods/v/IORequestable.svg?style=flat)](https://cocoapods.org/pods/IORequestable)
[![License](https://img.shields.io/cocoapods/l/IORequestable.svg?style=flat)](https://cocoapods.org/pods/IORequestable)
[![Platform](https://img.shields.io/cocoapods/p/IORequestable.svg?style=flat)](https://cocoapods.org/pods/IORequestable)

A **simple** way to define and execute your web API with IORequestable.

## What is it?

IORequestable provides an easy way to create web APIs by encapsulating codable input and output types together with URL request specifications based on an abstraction layer of Moya.

API = Codable Input + Decodable Output + URL/HTTPMethod/etc

## Usage

### Define an API

```swift
import IORequestable
import Moya

struct GetUserInfo: SomeIORequestable {

  var path: String { return "/user" }
  var method: Moya.Method { return .get }
  var input: Input?

  struct Input: Encodable {
    let accessToken: String
    let userID: Int
  }

  struct Output: Decodable {
    let name: String
    let gender: String?
    let height: Double?
    let weight: Double?
  }

}
```

### Execute an API

```swift
  GetUserInfo { $0.init(accessToken: "12345", userID: 5) }
    .execute() { result in
      switch result {
      case .success(let output):
        // ...
      case .failure(let error):
        // ...
      }
    }
```

## Sample Project

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

IORequestable is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'IORequestable'
```

## Author

royhcj, boyroyh@gmail.com

## License

IORequestable is available under the MIT license. See the LICENSE file for more info.
