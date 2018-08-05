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
  
}

extension MoyaIORequestable {
  
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


// Thanks to Joe Chiang for making MoyaProvidable with the smart design of one shared provider for each TargeType.
public protocol MoyaProvidable: TargetType {
    static var provider: MoyaProvider<Self> { get }
}

extension MoyaProvidable {
    public static var provider: MoyaProvider<Self> {
        //return MoyaProvider<Self>(plugins: [ExceptionMapPlugin()])
      return MoyaProvider<Self>(plugins: [])
    }
}


struct ExceptionMapPlugin: PluginType {
    
    func process(_ result:
        Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        switch result {
        case .success(let response):
            do {
                let json = try JSON.init(data: response.data)
                if json["statusCode"] == 0 {
                    return result
                } else {
                    guard
                        let errorString = json["statusMsg"].string,
                        let statsuCode = json["statusCode"].int else {
                            return Result<Response, MoyaError>.init(nil, failWith: .requestMapping("Error is from server but no statusMsg"))
                    }
                    return Result<Response, MoyaError>.init(nil, failWith: .requestMapping("statusCode: \(statsuCode), Msg: \(errorString)"))
                }
            } catch {
                return Result<Response, MoyaError>.init(nil, failWith: .requestMapping("parse json error"))
            }
        case .failure:
            return result
        }
    }
    
}
