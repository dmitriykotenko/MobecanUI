//  Copyright © 2020 Mobecan. All rights reserved.


import SnapKit
import UIKit


public extension UIView {
  
  static func zstack(padding: UIEdgeInsets = .zero,
                     _ subviews: [UIView]) -> Self {
    let stack = Self()
    
    subviews.forEach { subview in
      stack.addSubview(subview)
      subview.snp.makeConstraints { $0.edges.equalToSuperview().inset(padding) }
    }
    
    return stack
  }
  
  static func safeAreaZstack(padding: UIEdgeInsets = .zero,
                             _ subviews: [UIView]) -> Self {
    let stack = Self()
    
    subviews.forEach { subview in
      stack.addSubview(subview)
      subview.snp.makeConstraints { $0.edges.equalTo(stack.safeAreaLayoutGuide).inset(padding) }
    }
    
    return stack
  }
}
