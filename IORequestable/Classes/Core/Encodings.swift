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
    
  /// Encode input to HTTP body in Multipart/Form-data format
  case multipartFormDataBody
  
  /// Encode input to HTTP body in url-encoded format
  case urlEncodedBody // TODO: untested
  
  /// Encode input to URL query in url-encoded format
  case urlEncodedQuery
  
  // TODO: Support more encodings.
}

public enum OutputDecoding {
    /// Plain data. No decoding
    case rawData
    
    /// Decode json output
    case json
}
