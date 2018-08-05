//
//  GithubIORequestable.swift
//  IORequestable_Example
//
//  Created by roy on 8/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import IORequestable


protocol GithubIORequestable: MoyaIORequestable {
  var sampleDataFile: String? { get }
}

extension GithubIORequestable {
  
  var baseURL: URL {
    return URL(string: "https://api.github.com")!
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
}
