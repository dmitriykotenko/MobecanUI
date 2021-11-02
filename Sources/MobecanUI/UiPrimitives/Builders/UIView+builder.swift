//  Copyright © 2020 Mobecan. All rights reserved.

import SnapKit
import UIKit


public extension UIView {
  
  /// Disables view's dark appearance in iOS 13.
  func forcedLightAppearance() -> Self {
    if #available(iOS 13.0, *) {
      self.overrideUserInterfaceStyle = .light
    }
    return self
  }

  func withSingleSubview(_ subview: UIView) -> Self {
    putSubview(subview)
    return self
  }

  func cornerRadius(_ cornerRadius: CGFloat) -> Self {
    layer.cornerRadius = cornerRadius
    return self
  }
  
  func roundedCorners(_ roundedCorners: [Corner]) -> Self {
    layer.maskedCorners = CACornerMask(roundedCorners.map { $0.cornerMask })
    return self
  }

  func clipsToBounds(_ clipsToBounds: Bool) -> Self {
    self.clipsToBounds = clipsToBounds
    return self
  }

  func isVisible(_ isVisible: Bool) -> Self {
    self.isVisible = isVisible
    return self
  }

  func isHidden(_ isHidden: Bool) -> Self {
    self.isHidden = isHidden
    return self
  }

  func alpha(_ alpha: CGFloat) -> Self {
    self.alpha = alpha
    return self
  }

  func backgroundColor(_ backgroundColor: UIColor) -> Self {
    self.backgroundColor = backgroundColor
    return self
  }
  
  func shadowColor(_ shadowColor: UIColor?) -> Self {
    layer.shadowColor = shadowColor?.cgColor
    return self
  }

  func tintColor(_ tintColor: UIColor) -> Self {
    self.tintColor = tintColor
    return self
  }
  
  func borderColor(_ borderColor: UIColor?) -> Self {
    layer.borderColor = borderColor?.cgColor
    return self
  }
  
  func borderWidth(_ borderWidth: CGFloat) -> Self {
    layer.borderWidth = borderWidth
    return self
  }
  
  func border(_ border: Border) -> Self {
    borderColor(border.color).borderWidth(border.width)
  }
}
