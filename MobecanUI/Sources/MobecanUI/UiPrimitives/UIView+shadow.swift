//  Copyright © 2019 Mobecan. All rights reserved.


import SnapKit
import UIKit


public extension UIView {
  
  /// Do not use transparent background color. Otherwise, shadow disappears:
  /// https://stackoverflow.com/questions/12927626/shadow-not-showing-when-background-color-is-clear-color
  static func shadow(_ shadow: Shadow,
                     backgroundColor: UIColor,
                     cornerRadius: CGFloat = 0) -> UIView {
    return UIView()
      .backgroundColor(backgroundColor)
      .cornerRadius(cornerRadius)
      .withShadow(shadow)
  }
  
  func withShadow(_ shadow: Shadow) -> Self {
    layer.shadowColor = shadow.color.cgColor
    layer.shadowOpacity = shadow.opacity
    layer.shadowRadius = shadow.radius
    layer.shadowOffset = shadow.offset
    
    return self
  }
}
