// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIScrollView {
  
  func fittedTo(content: UIView,
                insets: UIEdgeInsets = .zero,
                axis: NSLayoutConstraint.Axis,
                width: CGFloat? = nil,
                height: CGFloat? = nil) -> Self {
    width.map { _ = content.autolayoutWidth($0) }
    height.map { _ = content.autolayoutHeight($0) }

    content.layoutIfNeeded()
    
    let contentSize = content.frame.inset(by: insets).size
    
    putSubview(content, insets: insets)
    
    switch axis {
    case .horizontal:
      _ = self.autolayoutHeight(contentSize.height)
    case .vertical:
      _ = self.autolayoutWidth(contentSize.width)
    @unknown default:
      fatalError("UIScrollView.fittedTo(content:insets:) does not yet support \(axis) axis.")
    }

    return self
  }
}
