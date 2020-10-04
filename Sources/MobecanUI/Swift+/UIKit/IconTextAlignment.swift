//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public enum IconTextAlignment: String, Equatable, Hashable, Codable {
  
  case xHeight
  case capHeight
  
  public func height(font: UIFont) -> CGFloat {
    switch self {
    case .xHeight:
      return font.xHeight
    case .capHeight:
      return font.capHeight
    }
  }
}
