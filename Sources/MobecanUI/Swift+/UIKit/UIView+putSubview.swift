// Copyright © 2020 Mobecan. All rights reserved.

import SnapKit
import UIKit


public enum SubviewPosition {
  
  case atIndex(Int)
  case above(UIView)
  case below(UIView)
}


public extension UIView {
  
  func putSubview(_ subview: UIView,
                  _ position: SubviewPosition? = nil,
                  insets: UIEdgeInsets = .zero) {
    addSubview(subview, position: position)
    
    subview.snp.makeConstraints { $0.edges.equalToSuperview().inset(insets) }
  }
  
  func putSubviewInsideSafeArea(_ subview: UIView,
                                _ position: SubviewPosition? = nil,
                                insets: UIEdgeInsets = .zero) {
    addSubview(subview, position: position)
    
    subview.snp.makeConstraints { $0.edges.equalTo(safeAreaLayoutGuide).inset(insets) }
  }
  
  private func addSubview(_ subview: UIView,
                          position: SubviewPosition?) {
    switch position {
    case .atIndex(let index):
      insertSubview(subview, at: index)
    case .above(let anotherSubview):
      insertSubview(subview, aboveSubview: anotherSubview)
    case .below(let anotherSubview):
      insertSubview(subview, belowSubview: anotherSubview)
    case nil:
      addSubview(subview)
    }
  }
}
