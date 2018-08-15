//
//  IORequestable+Moya+PlaceholdedPath.swift
//  IORequestable
//
//  Created by Roy Hu on 2018/8/15.
//

import Foundation


extension MoyaIORequestable {
  
  func resolvePlaceholdedPath(_ path: String) -> String {
    var path = path
    let ranges = Self.curlyBracketRanges(of: path)
    
    if ranges.isEmpty {
      return path
    }
    
    let data = try! JSONEncoder().encode(input)
    guard let parameters = try! JSONSerialization.jsonObject(
      with: data, options: .allowFragments
      ) as? [String: Any]
      else {
        print("Error: Failed encoding Input")
        return path
    }
    
    ranges.reversed().forEach {
      let key: String = String(path[$0.keyRange])
      if let value = parameters[key] {
        let subPath = String(describing: value)
        path.replaceSubrange($0.replaceRange, with: subPath)
      }
    }
    return path
  }
  
  private static func curlyBracketRanges(of text: String)
    -> [(keyRange: Range<String.Index>,
    replaceRange: Range<String.Index>)] {
      var ranges: [(keyRange: Range<String.Index>,
        replaceRange: Range<String.Index>)] = []
      
      var search: Substring = text.prefix(text.count)
      while let rangeL = search.range(of: "{")  {
        search = search.suffix(from: rangeL.upperBound)
        if let rangeR = search.range(of: "}") {
          let keyRange = Range<String.Index>(uncheckedBounds:
            (lower: rangeL.upperBound,
             upper: rangeR.lowerBound))
          let replaceRange = Range<String.Index>(uncheckedBounds:
            (lower: rangeL.lowerBound,
             upper: rangeR.upperBound))
          ranges.append((keyRange: keyRange,
                         replaceRange: replaceRange))
          search = search.suffix(from: rangeR.upperBound)
        }
      }
      return ranges
  }
}
