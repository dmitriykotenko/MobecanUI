// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UITextView {
  
  func setTextStyle(_ textStyle: TextStyle) {
    let currentFont = font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
    
    if let fontStyle = textStyle.fontStyle {
      font = fontStyle.apply(to: currentFont)
    }
    
    if let color = textStyle.color {
      textColor = color
    }
    
    if let alignment = textStyle.alignment {
      textAlignment = alignment
    }
  }
}
