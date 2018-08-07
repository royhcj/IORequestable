//
//  Requestable.swift
//  ziweiyun
//
//  Created by Roy Hu on 2018/8/1.
//  Copyright © 2018 larvata.com.tw. All rights reserved.
//

import Foundation
import Result

public protocol IORequestable {
  associatedtype Input: Encodable
  associatedtype Output: Decodable
  associatedtype ErrorT: Swift.Error
  var input: Input? { get set }
  
  init()
  init(input: Input)
  init(input: ((Input.Type) -> Input))
  
  func execute(completion: @escaping ((Result<Output, ErrorT>) -> Void))
}

extension IORequestable {
  public init(input: Input) {
    self.init()
    self.input = input
  }
  
  public init(input: ((Input.Type) -> Input)) {
    self.init()
    self.input = input(Input.self)
  }
  
  public var sampleData: Data { return Data() }
}
