//  Copyright © 2021 Mobecan. All rights reserved.

import SnapKit
import UIKit


public extension UIView {

  func translatesAutoresizingMaskIntoConstraints(_ translatesAutoresizingMaskIntoConstraints: Bool) -> Self {
    self.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
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

  func maximumWidth(_ width: CGFloat,
                    priority: ConstraintPriority = .required) -> Self {
    snp.makeConstraints { $0.width.lessThanOrEqualTo(width).priority(priority) }
    return self
  }

  func maximumHeight(_ height: CGFloat,
                     priority: ConstraintPriority = .required) -> Self {
    snp.makeConstraints { $0.height.lessThanOrEqualTo(height).priority(priority) }
    return self
  }

  func maximumSize(_ size: CGSize,
                   priority: ConstraintPriority = .required) -> Self {
    maximumWidth(size.width, priority: priority)
      .maximumHeight(size.height, priority: priority)
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
}
