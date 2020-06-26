//  Copyright © 2019 Mobecan. All rights reserved.

import UIKit


public enum Corner {
  
  case topLeft, bottomLeft, topRight, bottomRight
  
  public var cornerMask: CACornerMask {
    switch self {
    case .topLeft:
      return .layerMinXMinYCorner
    case .bottomLeft:
      return .layerMinXMaxYCorner
    case .topRight:
      return .layerMaxXMinYCorner
    case .bottomRight:
      return .layerMaxXMaxYCorner
    }
  }
}


public extension Array where Element == Corner {
  
  static var allCorners: [Corner] = [.topLeft, .bottomLeft, .topRight, .bottomRight]
  static var topCorners: [Corner] = [.topLeft, .topRight]
  static var bottomCorners: [Corner] = [.bottomLeft, .bottomRight]
}
