// Copyright © 2021 Mobecan. All rights reserved.

import SnapKit
import UIKit


public extension UIView {

  @discardableResult
  func translatesAutoresizingMaskIntoConstraints(_ translatesAutoresizingMaskIntoConstraints: Bool) -> Self {
    self.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
    return self
  }

  @discardableResult
  func autolayoutWidth(_ width: CGFloat,
                       priority: ConstraintPriority = .required) -> Self {
    snp.makeConstraints { $0.width.equalTo(width).priority(priority) }
    return self
  }

  @discardableResult
  func autolayoutHeight(_ height: CGFloat,
                        priority: ConstraintPriority = .required) -> Self {
    snp.makeConstraints { $0.height.equalTo(height).priority(priority) }
    return self
  }

  @discardableResult
  func autolayoutSize(_ size: CGSize,
                      priority: ConstraintPriority = .required) -> Self {
    autolayoutWidth(size.width, priority: priority)
      .autolayoutHeight(size.height, priority: priority)
  }

  @discardableResult
  func autolayoutMinimumWidth(_ width: CGFloat,
                              priority: ConstraintPriority = .required) -> Self {
    snp.makeConstraints { $0.width.greaterThanOrEqualTo(width).priority(priority) }
    return self
  }

  @discardableResult
  func autolayoutMinimumHeight(_ height: CGFloat,
                               priority: ConstraintPriority = .required) -> Self {
    snp.makeConstraints { $0.height.greaterThanOrEqualTo(height).priority(priority) }
    return self
  }

  @discardableResult
  func autolayoutMinimumSize(_ size: CGSize,
                             priority: ConstraintPriority = .required) -> Self {
    autolayoutMinimumWidth(size.width, priority: priority)
      .autolayoutMinimumHeight(size.height, priority: priority)
  }

  @discardableResult
  func autolayoutMaximumWidth(_ width: CGFloat,
                              priority: ConstraintPriority = .required) -> Self {
    snp.makeConstraints { $0.width.lessThanOrEqualTo(width).priority(priority) }
    return self
  }

  @discardableResult
  func autolayoutMaximumHeight(_ height: CGFloat,
                               priority: ConstraintPriority = .required) -> Self {
    snp.makeConstraints { $0.height.lessThanOrEqualTo(height).priority(priority) }
    return self
  }

  @discardableResult
  func autolayoutMaximumSize(_ size: CGSize,
                             priority: ConstraintPriority = .required) -> Self {
    autolayoutMaximumWidth(size.width, priority: priority)
      .autolayoutMaximumHeight(size.height, priority: priority)
  }

  @discardableResult
  func fitToContent(axis: [NSLayoutConstraint.Axis]) -> Self {
    self
      .contentHuggingPriority(.required, axis: axis)
      .contentCompressionResistancePriority(.required, axis: axis)
  }

  @discardableResult
  func contentHuggingPriority(_ priority: UILayoutPriority,
                              axis: [NSLayoutConstraint.Axis]) -> Self {
    axis.forEach {
      setContentHuggingPriority(priority, for: $0)
    }

    return self
  }

  @discardableResult
  func contentCompressionResistancePriority(_ priority: UILayoutPriority,
                                            axis: [NSLayoutConstraint.Axis]) -> Self {
    axis.forEach {
      setContentCompressionResistancePriority(priority, for: $0)
    }

    return self
  }

  @discardableResult
  func layoutMargins(_ layoutMargins: UIEdgeInsets) -> Self {
    (self as? UIStackView).map { $0.isLayoutMarginsRelativeArrangement = true }

    self.layoutMargins = layoutMargins
    return self
  }
}
