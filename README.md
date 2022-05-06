
<p align="center">
  <img height="160" src="web/logo_github.png" />
</p>

# IORequestable

[![CI Status](https://img.shields.io/travis/royhcj/IORequestable.svg?style=flat)](https://travis-ci.org/royhcj/IORequestable)
[![Version](https://img.shields.io/cocoapods/v/IORequestable.svg?style=flat)](https://cocoapods.org/pods/IORequestable)
[![License](https://img.shields.io/cocoapods/l/IORequestable.svg?style=flat)](https://cocoapods.org/pods/IORequestable)
[![Platform](https://img.shields.io/cocoapods/p/IORequestable.svg?style=flat)](https://cocoapods.org/pods/IORequestable)

A **simple** way to define and execute your web API requests with IORequestable in Swift.

## What is it?

IORequestable provides a clean and easy way to create web API requests by encapsulating codable input and output types together with URL request specifications based on an abstraction layer of Moya.

API = Encodable Input + Decodable Output + URL and other options

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
struct GetBestPerson: SomeIORequestable {

  var spec = Spec(.get, "/api/people/best",
                  inputEncoding: .urlParameter)

  struct Input: Encodable {
    let trait: String
    let gender: String?
  }

  struct Output: Decodable {
    let name: String
    let height: Double?
    let weight: Double?
  }

}
```

That's it! You have just created an executable API. Let's run it and give it a try.

### Execute an API request

```swift
  GetBestPerson(.init(trait: "kindness",
                      gender: "all"))
    .execute() { result in
      switch result {
      case .success(let output):
        // ...
      case .failure(let error):
        // ...
      }
    }
```

## Other tips

### Tip #1

To define path placeholders, use { } in path and @PathOnly for input parameters.

```swift
struct GetUserInfo: SomeIORequestable {
  var spec = Spec(.get, "/api/books/{bookID}") // Use { } for placeholder

  struct Input: Encodable {
    @PathOnly var bookID: String // Use @PathOnly
    var otherParameter: Int
  }

  struct Output = ...
}
```

### Tip #2

To use an existing model as Input or Output, use typealias.

```swift
struct GetUserInfo: SomeIORequestable {
  var spec = ...

  typealias Input = String // Define input as String

  typealias Output = Person // Use Person as Output,
                            // where Person conforms to Decodable.  
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
