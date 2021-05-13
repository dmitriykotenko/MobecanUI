//  Copyright © 2020 Mobecan. All rights reserved.


import SnapKit
import UIKit


public extension UIView {

  static func top(_ subview: UIView,
                  inset: CGFloat = 0,
                  priority: ConstraintPriority = .required) -> Self {
    let superview = Self()

    superview.disableTemporaryConstraints()

    superview.addSubview(subview)
    
    subview.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.lessThanOrEqualToSuperview()
      $0.top.equalToSuperview().inset(inset).priority(priority)
    }
    
    return superview
  }
  
  static func bottom(_ subview: UIView,
                     inset: CGFloat = 0,
                     priority: ConstraintPriority = .required) -> Self {
    let superview = Self()

    superview.disableTemporaryConstraints()

    superview.addSubview(subview)
    
    subview.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.greaterThanOrEqualToSuperview()
      $0.bottom.equalToSuperview().inset(inset).priority(priority)
    }
    
    return superview
  }
  
  static func leading(_ subview: UIView,
                      inset: CGFloat = 0,
                      priority: ConstraintPriority = .required) -> Self {
    let superview = Self()

    superview.disableTemporaryConstraints()

    superview.addSubview(subview)
    
    subview.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.trailing.lessThanOrEqualToSuperview()
      $0.leading.equalToSuperview().inset(inset).priority(priority)
    }
    
    return superview
  }
  
  static func trailing(_ subview: UIView,
                       inset: CGFloat = 0,
                       priority: ConstraintPriority = .required) -> Self {
    let superview = Self()

    superview.disableTemporaryConstraints()

    superview.addSubview(subview)
    
    subview.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.greaterThanOrEqualToSuperview()
      $0.trailing.equalToSuperview().inset(inset).priority(priority)
    }
    
    return superview
  }
}
