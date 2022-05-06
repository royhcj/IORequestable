//
//  PathOnly.swift
//  IORequestable
//
//  Created by Roy on 2022/5/6.
//

import Foundation

internal class JSONPathEncoder: JSONEncoder {
  static let pathOnlyKey: CodingUserInfoKey = .init(rawValue: "IORequestablePathOnly")!
  
  override init() {
    super.init()
    userInfo[JSONPathEncoder.pathOnlyKey] = true
  }
}

@propertyWrapper
public struct PathOnly<T: Codable>: Codable {
  public var wrappedValue: T
  
  public init(wrappedValue: T) {
    self.wrappedValue = wrappedValue
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    if (encoder.userInfo[JSONPathEncoder.pathOnlyKey] as? Bool) == true {
      try container.encode(wrappedValue)
    } else {
      // do nothing
    }
  }
  
}

extension KeyedEncodingContainer {
  public func encode<T>(_ type: PathOnly<T>.Type,
                        forKey key: Self.Key) throws {
    // Do nothing
    print("unimplemented")
  }
}
