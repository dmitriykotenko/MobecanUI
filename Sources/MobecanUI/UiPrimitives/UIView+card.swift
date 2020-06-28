//  Copyright © 2020 Mobecan. All rights reserved.


import SnapKit
import UIKit


public extension UIView {
  
  static func card(roundedCorners: [Corner] = .allCorners,
                   cornerRadius: CGFloat,
                   _ subview: UIView,
                   insets: UIEdgeInsets = .zero) -> UIView {
    
    return card(
      roundedCorners: roundedCorners,
      cornerRadius: cornerRadius,
      [subview],
      insets: insets
    )
  }
  
  static func card(roundedCorners: [Corner] = .allCorners,
                   cornerRadius: CGFloat,
                   _ subviews: [UIView] = [],
                   insets: UIEdgeInsets = .zero) -> UIView {
    let minimumSize = CGSize(
      width: insets.left + insets.right,
      height: insets.top + insets.bottom
    )
    
    // Do not insert vertical stack if card content must be empty.
    let card = subviews.isEmpty ?
      UIView().minimumSize(minimumSize) :
      UIView.vstack(subviews, insets: insets)
    
    return card
      .cornerRadius(cornerRadius)
      .roundedCorners(roundedCorners)
  }
}
