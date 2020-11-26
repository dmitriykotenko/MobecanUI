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
      $0.top.equalToSuperview().inset(inset).priority(priority)
      $0.leading.trailing.equalToSuperview()
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
      $0.bottom.equalToSuperview().inset(inset).priority(priority)
      $0.leading.trailing.equalToSuperview()
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
      $0.trailing.equalToSuperview().inset(inset).priority(priority)
    }
    
    return superview
  }

  static func centeredHorizontally(_ subview: UIView,
                                   offset: CGFloat = 0,
                                   priority: ConstraintPriority = .required) -> Self {
    let superview = Self()
    
    superview.disableTemporaryConstraints()

    superview.addSubview(subview)
    
    subview.snp.makeConstraints {
      $0.centerX.equalToSuperview().offset(offset).priority(priority)
      $0.top.bottom.equalToSuperview()
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
}
