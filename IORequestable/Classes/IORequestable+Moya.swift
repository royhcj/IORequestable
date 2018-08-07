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
    let data = try! JSONEncoder().encode(input)
    guard let parameters = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      print("Error: Failed encoding Input")
      return .requestPlain
    }
    return Task.requestParameters(parameters: parameters, encoding: URLEncoding.default)
  }
  
  public var headers: [String: String]? {
    return ["Content-type":"application/json"]
  }
  
  public func execute(completion: @escaping ((Result<Output, MoyaError>) -> Void)) {
    Self.provider.request(self) { (result) in
      switch result {
      case .success(let response):
        let output = try? JSONDecoder().decode(Output.self, from: response.data)
        if let output = output {
          completion(Result<Output, MoyaError>.init(value: output))
        } else {
          completion(Result<Output, MoyaError>.init(error: MoyaError.encodableMapping("Output encoding error")))
        }
      case .failure(let error):
        completion(Result<Output, MoyaError>.init(error: error))
      }
    }
  }
  
}


// Thanks to Joe Jiang for making MoyaProvidable with the smart design having one shared provider for each TargeType.
public protocol MoyaProvidable: TargetType {
    static var provider: MoyaProvider<Self> { get }
}


public struct MoyaSpec {
  public var method: Moya.Method
  public var path: String
  
  public var input: Any?
  
  public init(_ method: Moya.Method, _ path: String) {
    self.method = method
    self.path = path
  }
}
