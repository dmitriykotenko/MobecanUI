//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIButton {
  
  func setTextStyle(_ textStyle: TextStyle) {
    guard let titleLabel = titleLabel else { return }
    
    if let fontStyle = textStyle.fontStyle {
      titleLabel.font = fontStyle.apply(to: titleLabel.font)
    }
    
    if let color = textStyle.color {
      setTitleColor(color, for: .normal)
    }
    
    if let alignment = textStyle.alignment {
      titleLabel.textAlignment = alignment
    }
  }
}
