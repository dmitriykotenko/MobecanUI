// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIView {
  
  func putSingleSubview(_ subview: UIView,
                        _ position: SubviewPosition? = nil,
                        insets: UIEdgeInsets = .zero) {
    removeAllSubviews()
    
    putSubview(subview, position, insets: insets)
  }
  
  func putSingleSubviewInsideSafeArea(_ subview: UIView,
                                      _ position: SubviewPosition? = nil,
                                      insets: UIEdgeInsets = .zero) {
    removeAllSubviews()
    
    putSubviewInsideSafeArea(subview, position, insets: insets)
  }
}
