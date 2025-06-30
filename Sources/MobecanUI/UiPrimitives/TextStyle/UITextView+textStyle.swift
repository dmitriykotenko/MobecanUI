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

  func setTextStyle2(_ textStyle: TextStyle2) {
    let currentFont = font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)

    if let fontStyle = textStyle.fontStyle {
      font = fontStyle.apply(to: currentFont)
    }

    if let color = textStyle.color {
      textColor = color.uiColor
    }

    if let alignment = textStyle.alignment {
      textAlignment = alignment.nsTextAlignment
    }
  }
}
