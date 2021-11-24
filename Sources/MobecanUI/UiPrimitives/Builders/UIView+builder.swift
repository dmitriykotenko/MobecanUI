//  Copyright © 2020 Mobecan. All rights reserved.

import SnapKit
import UIKit


public extension UIView {
  
  /// Disables view's dark appearance in iOS 13.
  @discardableResult
  func forcedLightAppearance() -> Self {
    if #available(iOS 13.0, *) {
      self.overrideUserInterfaceStyle = .light
    }
    return self
  }

  @discardableResult
  func withSingleSubview(_ subview: UIView) -> Self {
    putSubview(subview)
    return self
  }

  @discardableResult
  func cornerRadius(_ cornerRadius: CGFloat) -> Self {
    layer.cornerRadius = cornerRadius
    return self
  }
  
  @discardableResult
  func roundedCorners(_ roundedCorners: [Corner]) -> Self {
    layer.maskedCorners = CACornerMask(roundedCorners.map { $0.cornerMask })
    return self
  }

  @discardableResult
  func clipsToBounds(_ clipsToBounds: Bool) -> Self {
    self.clipsToBounds = clipsToBounds
    return self
  }

  @discardableResult
  func isVisible(_ isVisible: Bool) -> Self {
    self.isVisible = isVisible
    return self
  }

  @discardableResult
  func isHidden(_ isHidden: Bool) -> Self {
    self.isHidden = isHidden
    return self
  }

  @discardableResult
  func alpha(_ alpha: CGFloat) -> Self {
    self.alpha = alpha
    return self
  }

  @discardableResult
  func backgroundColor(_ backgroundColor: UIColor) -> Self {
    self.backgroundColor = backgroundColor
    return self
  }
  
  @discardableResult
  func shadowColor(_ shadowColor: UIColor?) -> Self {
    layer.shadowColor = shadowColor?.cgColor
    return self
  }

  @discardableResult
  func tintColor(_ tintColor: UIColor) -> Self {
    self.tintColor = tintColor
    return self
  }
  
  @discardableResult
  func borderColor(_ borderColor: UIColor?) -> Self {
    layer.borderColor = borderColor?.cgColor
    return self
  }
  
  @discardableResult
  func borderWidth(_ borderWidth: CGFloat) -> Self {
    layer.borderWidth = borderWidth
    return self
  }

  @discardableResult
  func border(_ border: Border) -> Self {
    borderColor(border.color).borderWidth(border.width)
  }
}
