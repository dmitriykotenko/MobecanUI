//  Copyright © 2020 Mobecan. All rights reserved.


import SnapKit
import UIKit


public extension UIView {
  
  static func card(roundedCorners: [Corner] = .allCorners,
                   cornerRadius: CGFloat,
                   padding: UIEdgeInsets,
                   _ subview: UIView) -> UIView {
    
    return card(
      roundedCorners: roundedCorners,
      cornerRadius: cornerRadius,
      padding: padding,
      [subview]
    )
  }
  
  static func card(roundedCorners: [Corner] = .allCorners,
                   cornerRadius: CGFloat,
                   padding: UIEdgeInsets,
                   _ subviews: [UIView] = []) -> UIView {
    let minimumSize = CGSize(
      width: padding.left + padding.right,
      height: padding.top + padding.bottom
    )
    
    // Do not insert vertical stack if card content must be empty.
    let card = subviews.isEmpty ?
      UIView().minimumSize(minimumSize) :
      UIView.vstack(padding: padding, subviews)
    
    return card
      .cornerRadius(cornerRadius)
      .roundedCorners(roundedCorners)
  }
}
