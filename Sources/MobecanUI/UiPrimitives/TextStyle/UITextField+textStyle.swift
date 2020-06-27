//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UITextField {
  
  func setTextStyle(_ textStyle: TextStyle) {
    if let currentFont = font, let fontStyle = textStyle.fontStyle {
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
