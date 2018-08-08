
<p align="center">
  <img height="160" src="web/logo_github.png" />
</p>

# IORequestable

[![CI Status](https://img.shields.io/travis/royhcj/IORequestable.svg?style=flat)](https://travis-ci.org/royhcj/IORequestable)
[![Version](https://img.shields.io/cocoapods/v/IORequestable.svg?style=flat)](https://cocoapods.org/pods/IORequestable)
[![License](https://img.shields.io/cocoapods/l/IORequestable.svg?style=flat)](https://cocoapods.org/pods/IORequestable)
[![Platform](https://img.shields.io/cocoapods/p/IORequestable.svg?style=flat)](https://cocoapods.org/pods/IORequestable)

A **simple** way to define and execute your web API with IORequestable in Swift.

## What is it?

IORequestable provides a clean and easy way to create web APIs by encapsulating codable input and output types together with URL request specifications based on an abstraction layer of Moya.

API = Endable Input + Decodable Output + URL and other options

## Usage

### Specify a shared base URL

```swift
import IORequestable
import Moya

protocol SomeIORequestable: MoyaIORequestable {}
extension SomeIORequestable {
  var baseURL: URL {
    return URL(string: "https://example.com")!
  }
}
```

### Define an API

```swift
struct GetUserInfo: SomeIORequestable {

  var spec = Spec(.get, "/user",
                  inputEncoding: .urlParameter)

  struct Input: Encodable {
    let userID: Int
    let language: String?
  }

  struct Output: Decodable {
    let name: String
    let height: Double?
    let weight: Double?
  }

}
```

That's it! You have just created an executable API. Let's run it and give it a try.

### Execute an API

```swift
  GetUserInfo { $0.init(userID: 5, language: "en_us") }
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
