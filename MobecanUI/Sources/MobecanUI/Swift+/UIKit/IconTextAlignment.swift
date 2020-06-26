//  Copyright © 2019 Mobecan. All rights reserved.

import UIKit


public enum IconTextAlignment {
  
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
