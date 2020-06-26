//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIView {
  
  static func blur(style: UIBlurEffect.Style) -> Self {
    return .zstack([
      UIVisualEffectView(effect: UIBlurEffect(style: style))
    ])
  }
}
