//  Copyright © 2020 Mobecan. All rights reserved.

import SnapKit
import UIKit


public extension UIView {

  static func centeredHorizontally(_ subview: UIView,
                                   offset: CGFloat = 0,
                                   priority: ConstraintPriority = .required) -> Self {
    let superview = Self()
    
    superview.disableTemporaryConstraints()

    superview.addSubview(subview)
    
    subview.snp.makeConstraints {
      $0.centerX.equalToSuperview().offset(offset).priority(priority)
      $0.top.bottom.equalToSuperview()

      $0.left.greaterThanOrEqualToSuperview()
      $0.right.lessThanOrEqualToSuperview()
    }
    
    return superview
  }

  static func centeredVertically(_ subview: UIView,
                                 offset: CGFloat = 0,
                                 priority: ConstraintPriority = .required) -> Self {
    let superview = Self()
    
    superview.disableTemporaryConstraints()

    superview.addSubview(subview)
    
    subview.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.centerY.equalToSuperview().offset(offset).priority(priority)

      $0.top.greaterThanOrEqualToSuperview()
      $0.bottom.lessThanOrEqualToSuperview()
    }
    
    return superview
  }

  static func centered(_ subview: UIView,
                       offset: CGSize = .zero,
                       priority: ConstraintPriority = .required) -> Self {
    let superview = Self()

    superview.disableTemporaryConstraints()

    superview.addSubview(subview)

    subview.snp.makeConstraints {
      $0.centerX.equalToSuperview().offset(offset.width).priority(priority)
      $0.centerY.equalToSuperview().offset(offset.height).priority(priority)
    }

    return superview
  }
}
