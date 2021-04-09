//  Copyright © 2020 Mobecan. All rights reserved.

import SnapKit
import UIKit


public extension UIView {

  static func topLeading(_ subview: UIView,
                         topInset: CGFloat = 0,
                         leadingInset: CGFloat = 0,
                         priority: ConstraintPriority = .required) -> Self {
    let superview = Self()
    
    superview.disableTemporaryConstraints()

    superview.addSubview(subview)
    
    subview.snp.makeConstraints {
      $0.top.equalToSuperview().inset(topInset).priority(priority)
      $0.leading.equalToSuperview().inset(leadingInset).priority(priority)
    }
    
    return superview
  }

  static func topTrailing(_ subview: UIView,
                          topInset: CGFloat = 0,
                          trailingInset: CGFloat = 0,
                          priority: ConstraintPriority = .required) -> Self {
    let superview = Self()

    superview.disableTemporaryConstraints()

    superview.addSubview(subview)
    
    subview.snp.makeConstraints {
      $0.top.equalToSuperview().inset(topInset).priority(priority)
      $0.trailing.equalToSuperview().inset(trailingInset).priority(priority)
    }
    
    return superview
  }

  static func bottomLeading(_ subview: UIView,
                            bottomInset: CGFloat = 0,
                            leadingInset: CGFloat = 0,
                            priority: ConstraintPriority = .required) -> Self {
    let superview = Self()

    superview.addSubview(subview)

    subview.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(bottomInset).priority(priority)
      $0.leading.equalToSuperview().inset(leadingInset).priority(priority)
    }

    return superview
  }

  static func bottomTrailing(_ subview: UIView,
                             bottomInset: CGFloat = 0,
                             trailingInset: CGFloat = 0,
                             priority: ConstraintPriority = .required) -> Self {
    let superview = Self()

    superview.addSubview(subview)

    subview.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(bottomInset).priority(priority)
      $0.trailing.equalToSuperview().inset(trailingInset).priority(priority)
    }

    return superview
  }
}
