//
//  CodableOptions.swift
//  Alamofire
//
//  Created by Roy Hu on 2019/9/23.
//

import Foundation

// MARK: - JSON Encoder Key Strategy
public protocol JsonEncodableKeyStrategic {
  static var encodableKeyStrategy: JSONEncoder.KeyEncodingStrategy { get }
}

public protocol JsonEncodableKeyStrategyToSnakeCase: JsonEncodableKeyStrategic {
}

extension JsonEncodableKeyStrategyToSnakeCase {
  public static var encodableKeyStrategy: JSONEncoder.KeyEncodingStrategy {
    return .convertToSnakeCase
  }
}

public class JsonEncodableKeyStrategy {
  /**
   To encode parameter keys into snake case, simply conform to this protocol.
   For example:
          struct Input: Encodable, JsonEncodableKeyStrategy.ToSnakeCase {
            var someInt: Int
            var someString: String
          }
      produces something like:
          ?some_int=5&some_string=hello
   */
  public typealias ToSnakeCase = JsonEncodableKeyStrategyToSnakeCase
}

// MARK: - JSON Decoder Key Strategy
public protocol JsonDecodableKeyStrategic {
  static var decodableKeyStrategy: JSONDecoder.KeyDecodingStrategy { get }
}

public protocol JsonDecodableKeyStrategicFromSnakeCase: JsonDecodableKeyStrategic {
}

extension JsonDecodableKeyStrategicFromSnakeCase {
  public static var decodableKeyStrategy: JSONDecoder.KeyDecodingStrategy {
    return .convertFromSnakeCase
  }
}

public class JsonDecodableKeyStrategy {
  /**
   To decode response with keys in snake case, simply conform to this protocol.
   For example, to decode some response like:
          { "some_int": 5,
            "some_string": "hello"
          }
      declare your Output as follows:
          struct Output: Decodable, JsonDecodableKeyStrategy.FromSnakeCase {
            var someInt: Int
            var someString: String
          }

   */
  public typealias FromSnakeCase = JsonDecodableKeyStrategicFromSnakeCase
}

