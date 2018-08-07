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
  
  /// Encode input to URL as url-encoded parameters
  case urlParameter
  
  // TODO: Support more encodings.
}
