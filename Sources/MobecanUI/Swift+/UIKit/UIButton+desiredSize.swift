// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIButton {
  
  func desiredSize(height: CGFloat) -> CGSize {
    guard let font = titleLabel?.font else { return .zero }
    
    let currentTitle = title(for: .normal) ?? ""
    
    return CGSize(
      width: currentTitle.width(forFont: font) + contentEdgeInsets.left + contentEdgeInsets.right,
      height: height
    )
  }
}
