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
  var sampleDataFile: String? { get }
}

extension iTunesIORequestable {
  
  var baseURL: URL {
    return URL(string: "https://itunes.apple.com")!
  }
  
  var sampleData: Data {
    guard let sampleDataFile = sampleDataFile else {
      print("Error: sampleDataFile unspecified")
      return Data()
    }
    let path = Bundle.main.path(forResource: sampleDataFile, ofType: "json")
    return try! Data(contentsOf: URL(fileURLWithPath: path!))
  }
  
  var sampleDataFile: String? { return nil }
  
  public static var provider: MoyaProvider<Self> {
    return MoyaProvider<Self>(plugins: [])
  }
}
