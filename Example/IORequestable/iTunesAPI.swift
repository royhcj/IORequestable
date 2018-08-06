//
//  iTunesAPI.swift
//  IORequestable_Example
//
//  Created by roy on 8/6/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import IORequestable
import Moya

class iTunesAPI {
  
  struct SearchItems: iTunesIORequestable {
    var path: String { return "/search" }
    var method: Moya.Method { return .get }
    var input: Input?
    
    struct Input: Encodable {
      var term: String
      var limit: Int?
      var lang: String?
    }
    
    struct Output: Decodable {
      let resultCount: Int
      let results: [Item]?
      
      struct Item: Decodable {
        let wrapperType: String
        let kind: String
        let trackName: String?
        let artistId: Int?
        let artistName: String?
        let previewUrl: String?
      }
    }
  }
  
}
