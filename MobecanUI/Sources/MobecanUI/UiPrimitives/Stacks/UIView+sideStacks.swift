//  Copyright © 2020 Mobecan. All rights reserved.


import SnapKit
import UIKit


public extension UIView {

  static func top(_ subview: UIView, inset: CGFloat = 0) -> Self {
    let superview = Self()

    superview.addSubview(subview)
    
    subview.snp.makeConstraints {
      $0.top.equalToSuperview().inset(inset)
      $0.leading.trailing.equalToSuperview()
    }
    
    return superview
  }
  
  static func bottom(_ subview: UIView, inset: CGFloat = 0) -> Self {
    let superview = Self()

    superview.addSubview(subview)
    
    subview.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(inset)
      $0.leading.trailing.equalToSuperview()
    }
    
    return superview
  }
  
  static func leading(_ subview: UIView, inset: CGFloat = 0) -> Self {
    let superview = Self()

    superview.addSubview(subview)
    
    subview.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.equalToSuperview().inset(inset)
    }
    
    return superview
  }
  
  static func trailing(_ subview: UIView, inset: CGFloat = 0) -> Self {
    let superview = Self()

    superview.addSubview(subview)
    
    subview.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.trailing.equalToSuperview().inset(inset)
    }
    
    return superview
  }

  static func centered(axis: [NSLayoutConstraint.Axis] = [.horizontal, .vertical],
                       _ subview: UIView) -> Self {
    let superview = Self()

    superview.addSubview(subview)

    if axis.contains(.horizontal) {
      subview.snp.makeConstraints { $0.centerX.equalToSuperview() }
    } else {
      subview.snp.makeConstraints { $0.leading.trailing.equalToSuperview() }
    }

    if axis.contains(.vertical) {
      subview.snp.makeConstraints { $0.centerY.equalToSuperview() }
    } else {
      subview.snp.makeConstraints { $0.top.bottom.equalToSuperview() }
    }

    return superview
  }
  
  static func topLeading(_ subview: UIView,
                         topInset: CGFloat = 0,
                         leadingInset: CGFloat = 0) -> Self {
    let superview = Self()
    
    superview.addSubview(subview)
    
    subview.snp.makeConstraints {
      $0.top.equalToSuperview().inset(topInset)
      $0.leading.equalToSuperview().inset(leadingInset)
    }
    
    return superview
  }

  static func topTrailing(_ subview: UIView,
                          topInset: CGFloat = 0,
                          trailingInset: CGFloat = 0) -> Self {
    let superview = Self()

    superview.addSubview(subview)
    
    subview.snp.makeConstraints {
      $0.top.equalToSuperview().inset(topInset)
      $0.trailing.equalToSuperview().inset(trailingInset)
    }
    
    return superview
  }
}
