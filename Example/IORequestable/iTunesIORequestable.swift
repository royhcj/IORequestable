//
//  iTunesIORequestable.swift
//  IORequestable_Example
//
//  Created by roy on 8/6/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

import Foundation
import IORequestable
import Moya

protocol iTunesIORequestable: MoyaIORequestable,
                              RxIORequestable {
}

extension iTunesIORequestable {
  var baseURL: URL {
    return URL(string: "https://itunes.apple.com")!
  }
  
  public static var provider: MoyaProvider<Self> {
      let logger = BasicNetworkLoggerPlugin(verbose: true, cURL: true)
      
      return MoyaProvider<Self>(plugins: [logger])
  }
}
