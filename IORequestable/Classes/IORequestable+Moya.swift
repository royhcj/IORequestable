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

public protocol MoyaIORequestable: IORequestable, MoyaProvidable {
  typealias Spec = MoyaSpec
  
  var spec: Spec { get set }
}

extension MoyaIORequestable {
  
  public var path: String {
    return spec.path
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
    
    let inputEncoding = spec.inputEncoding ?? InputEncoding.plain
    
    switch inputEncoding {
    case .plain:
      return Task.requestPlain
    case .jsonBody:
      return Task.requestJSONEncodable(input)
    case .urlParameter:
      do {
        let data = try JSONEncoder().encode(input)
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
          let output = try JSONDecoder().decode(Output.self, from: response.data)
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
  public var inputEncoding: InputEncoding?
  
  public var input: Any?
  
  public init(_ method: Moya.Method,
              _ path: String,
              inputEncoding: InputEncoding? = nil) {
    self.method = method
    self.path = path
    self.inputEncoding = inputEncoding
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
