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
  
  func width(_ width: CGFloat,
             priority: ConstraintPriority = .required) -> Self {
    snp.makeConstraints { $0.width.equalTo(width).priority(priority) }
    return self
  }
  
  func height(_ height: CGFloat,
              priority: ConstraintPriority = .required) -> Self {
    snp.makeConstraints { $0.height.equalTo(height).priority(priority) }
    return self
  }
  
  func size(_ size: CGSize,
            priority: ConstraintPriority = .required) -> Self {
    width(size.width, priority: priority)
      .height(size.height, priority: priority)
  }

  func minimumWidth(_ width: CGFloat,
                    priority: ConstraintPriority = .required) -> Self {
    snp.makeConstraints { $0.width.greaterThanOrEqualTo(width).priority(priority) }
    return self
  }

  func minimumHeight(_ height: CGFloat,
                     priority: ConstraintPriority = .required) -> Self {
    snp.makeConstraints { $0.height.greaterThanOrEqualTo(height).priority(priority) }
    return self
  }
  
  func minimumSize(_ size: CGSize,
                   priority: ConstraintPriority = .required) -> Self {
    minimumWidth(size.width, priority: priority)
      .minimumHeight(size.height, priority: priority)
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
  
  func fitToContent(axis: [NSLayoutConstraint.Axis]) -> Self {
    self
      .contentHuggingPriority(.required, axis: axis)
      .contentCompressionResistancePriority(.required, axis: axis)
  }

  func contentHuggingPriority(_ priority: UILayoutPriority,
                              axis: [NSLayoutConstraint.Axis]) -> Self {
    axis.forEach {
      setContentHuggingPriority(priority, for: $0)
    }

    return self
  }

  func contentCompressionResistancePriority(_ priority: UILayoutPriority,
                                            axis: [NSLayoutConstraint.Axis]) -> Self {
    axis.forEach {
      setContentCompressionResistancePriority(priority, for: $0)
    }

    return self
  }

  func layoutMargins(_ layoutMargins: UIEdgeInsets) -> Self {
    (self as? UIStackView).map { $0.isLayoutMarginsRelativeArrangement = true }
    
    self.layoutMargins = layoutMargins
    return self
  }
  
  func withSingleSubview(_ subview: UIView) -> Self {
    putSubview(subview)
    return self
  }
}
