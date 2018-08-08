//
//  GithubIORequestable.swift
//  IORequestable_Example
//
//  Created by roy on 8/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import IORequestable
import Moya


protocol GithubIORequestable: MoyaIORequestable {
}

extension GithubIORequestable {
  var baseURL: URL {
    return URL(string: "https://api.github.com")!
  }
}
