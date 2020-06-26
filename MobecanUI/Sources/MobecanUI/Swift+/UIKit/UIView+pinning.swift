//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import SnapKit
import UIKit


public extension UIView {
    
  func pin(_ subview: UIView,
           to anotherSubview: UIView,
           insets: UIEdgeInsets = .zero) {
    subview.snp.makeConstraints { $0.edges.equalToSuperview().inset(insets) }
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
