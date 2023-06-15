//
//  Requestable.swift
//  ziweiyun
//
//  Created by Roy Hu on 2018/8/1.
//  Copyright © 2018 larvata.com.tw. All rights reserved.
//

import Foundation

public protocol IORequestable {
  associatedtype Input: Encodable
  associatedtype Output: Decodable
  associatedtype ErrorT: CustomizableError
  var input: Input? { get set }
  
  init()
  init(_ input: Input)
  init(input: ((Input.Type) -> Input))
  
  func execute(completion: @escaping ((Result<Output, ErrorT>) -> Void))
  func executeJust(completion: @escaping (Output?) -> Void)
}

extension IORequestable {
  public init(_ input: Input) {
    self.init()
    self.input = input
  }
  
  public init(input: ((Input.Type) -> Input)) {
    self.init()
    self.input = input(Input.self)
  }
}
