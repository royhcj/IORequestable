//
//  IORequestable+Moya.swift
//  Dishrank
//
//  Created by Roy Hu on 2018/8/1.
//

import Foundation
import Moya
import Result
import SwiftyJSON

public protocol MoyaIORequestable: IORequestable,
                                   MoyaProvidable {
  typealias Spec = MoyaSpec
  
  var spec: Spec { get set }
}

extension MoyaIORequestable {
  
  public var path: String {
    return resolvePlaceholdedPath(spec.path)
  }
  
  public var method: Moya.Method {
    return spec.method
  }
  
  public var input: Input? {
    get {
      return spec.input as? Input
    }
    set {
      spec.input = newValue
    }
  }
  
  public var task: Task {

    switch spec.inputEncoding {
    case .plain:
      return Task.requestPlain
    case .jsonBody:
      let encoder = JSONEncoder()
      if let strategy = Input.self as? JsonEncodableKeyStrategic.Type {
        encoder.keyEncodingStrategy = strategy.encodableKeyStrategy
      }
      return Task.requestCustomJSONEncodable(input, encoder: encoder)
    case .urlParameter:
      do {
        let encoder = JSONEncoder()
        if let strategy = Input.self as? JsonEncodableKeyStrategic.Type {
          encoder.keyEncodingStrategy = strategy.encodableKeyStrategy
        }

        let data = try encoder.encode(input)
        if let parameters = try JSONSerialization.jsonObject(with: data,
                                    options: .allowFragments) as? [String: Any] {
          return Task.requestParameters(parameters: parameters,
                                        encoding: URLEncoding.default)
        }
      } catch(let error) {
        print(error)
      }
    }
    
    return Task.requestPlain
  }
  
  public var headers: [String: String]? {
    return nil
  }
  
  public var sampleData: Data {
    return Data()
  }
  
  public func execute(completion: @escaping ((Result<Output, MoyaError>) -> Void)) {
    Self.provider.request(self) { (result) in
      switch result {
      case .success(let response):
        do {
            var output: Output
            switch self.spec.outputDecoding {
            case .rawData:
                guard let data = response.data as? Output
                    else {
                        let context = DecodingError.Context(codingPath: [], debugDescription: "[IORequestable] Error: Failed decoding response data: Output type must be Data.")
                        throw DecodingError.dataCorrupted(context)
                }
                output = data
            case .json:
                let decoder = JSONDecoder()
                if let strategy = Output.self as? JsonDecodableKeyStrategic.Type {
                  decoder.keyDecodingStrategy = strategy.decodableKeyStrategy
                }

                output = try decoder.decode(Output.self, from: response.data)
            }
            completion(Result<Output, MoyaError>.init(value: output))
        } catch(let error) {
          completion(Result<Output, MoyaError>.init(error: MoyaError.encodableMapping(error)))
        }
      case .failure(let error):
        completion(Result<Output, MoyaError>.init(error: error))
      }
    }
  }
  
  public func executeJust(completion: @escaping (Output?) -> Void) {
    execute { result in
      switch result {
      case .success(let output):
        completion(output)
      case .failure(_):
        completion(nil)
      }
    }
  }
  
}


// Thanks to Joe Jiang for making MoyaProvidable with the smart design having one shared provider for each TargeType.
public protocol MoyaProvidable: TargetType {
    static var provider: MoyaProvider<Self> { get }
}

extension MoyaIORequestable {
  public static var provider: MoyaProvider<Self> {
    return MoyaProvider<Self>(plugins: [])
  }
}


public struct MoyaSpec {
  public var method: Moya.Method
  public var path: String
  public var inputEncoding: InputEncoding = .urlParameter
  public var outputDecoding: OutputDecoding = .json
  
  public var input: Any?
  
  public init(_ method: Moya.Method,
              _ path: String,
              inputEncoding: InputEncoding? = nil,
              outputDecoding: OutputDecoding? = nil) {
    self.method = method
    self.path = path
    if let inputEncoding = inputEncoding {
        self.inputEncoding = inputEncoding
    }
    if let outputDecoding = outputDecoding {
        self.outputDecoding = outputDecoding
    }
  }
}


extension MoyaError: CustomizableError {
  public static func ior_customizedError(error: Error) -> MoyaError {
    if error is MoyaError {
      return error as! MoyaError
    } else {
      return .underlying(error, nil)
    }
  }
}
