//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIView {
  
  static func strikedOut(_ contentView: UIView,
                         border: Border) -> UIView {
    let topLine = UIView
      .spacer(height: border.width)
      .backgroundColor(border.color)
      
    return .zstack([
      contentView,
      .top(topLine).clickThrough()
    ])
  }
}
