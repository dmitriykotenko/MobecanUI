// Copyright © 2020 Mobecan. All rights reserved.


import UIKit


public extension UIView {
  
  static func card(roundedCorners: [Corner] = .allCorners,
                   cornerRadius: CGFloat,
                   _ subview: UIView,
                   insets: UIEdgeInsets = .zero) -> UIView {
    card(
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
    // Do not insert vertical stack if card content must be empty.
    let card = subviews.isEmpty ?
      UIView.stretchableSpacer(
        minimumWidth: insets.left + insets.right,
        minimumHeight: insets.top + insets.bottom
      ) :
      UIView.vstack(subviews, insets: insets)
    
    return card
      .cornerRadius(cornerRadius)
      .roundedCorners(roundedCorners)
  }
}
