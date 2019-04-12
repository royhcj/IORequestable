//
//  ParameterEncoding.swift
//  IORequestable
//
//  Created by Roy Hu on 2018/8/7.
//

import Foundation

public enum InputEncoding {
  
  /// No input
  case plain
  
  /// Encode input to HTTP body in JSON format
  case jsonBody
  
  /// Encode input to URL as url-encoded query string
  case urlParameter
  
  // TODO: Support more encodings.
}

public enum OutputDecoding {
    /// Plain data. No decoding
    case rawData
    
    /// Decode json output
    case json
}
