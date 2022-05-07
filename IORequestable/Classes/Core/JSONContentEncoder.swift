//
//  JSONContentEncoder.swift
//  IORequestable
//
//  Created by Roy on 2022/5/7.
//

import Foundation

internal class JSONContentEncoder: JSONEncoder {
  
  override func encode<T>(_ value: T) throws -> Data where T : Encodable {
    var data = try super.encode(value)
    let json = try JSONSerialization.jsonObject(
                        with: data, options: .allowFragments)
    
    if var object = json as? [String: Any?] {
      object = object.filter({ (key, value) in
        value != nil
      })
      data = try JSONSerialization.data(withJSONObject: object, options: .fragmentsAllowed)
    }
    return data
  }
  
}
