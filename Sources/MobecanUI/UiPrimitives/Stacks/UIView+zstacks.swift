//  Copyright © 2020 Mobecan. All rights reserved.

import SnapKit
import UIKit


public extension UIView {
  
  static func zstack(_ subviews: [UIView],
                     insets: UIEdgeInsets = .zero) -> Self {
    let stack = Self()

    stack.disableTemporaryConstraints()
    
    subviews.forEach { subview in
      stack.addSubview(subview)
      subview.snp.makeConstraints { $0.edges.equalToSuperview().inset(insets) }
    }
    
    return stack
  }
  
  static func safeAreaZstack(_ subviews: [UIView],
                             insets: UIEdgeInsets = .zero) -> Self {
    let stack = Self()

    stack.disableTemporaryConstraints()

    subviews.forEach { subview in
      stack.addSubview(subview)
      subview.snp.makeConstraints { $0.edges.equalTo(stack.safeAreaLayoutGuide).inset(insets) }
    }
    
    return stack
  }
}
