//
//  CustomizableError.swift
//  IORequestable
//
//  Created by Roy Hu on 2018/8/14.
//

import Foundation

public protocol CustomizableError: Error {
  static func ior_customizedError(error: Error) -> Self
}
