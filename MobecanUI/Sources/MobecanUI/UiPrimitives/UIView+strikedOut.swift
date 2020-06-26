//  Copyright © 2019 Mobecan. All rights reserved.

import UIKit


public extension UIView {
  
  // TODO: Border struct
  static func strikedOut(_ contentView: UIView,
                         lineWidth: CGFloat,
                         lineColor: UIColor) -> UIView {
    
    let topLine = UIView
      .spacer(height: lineWidth)
      .backgroundColor(lineColor)
      
    return .zstack([
      .top(topLine),
      contentView
    ])
  }
}
