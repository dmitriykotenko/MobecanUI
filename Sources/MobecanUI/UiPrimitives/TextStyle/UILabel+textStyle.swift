// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UILabel {
  
  func setTextStyle(_ textStyle: TextStyle) {
    if let fontStyle = textStyle.fontStyle {
      font = fontStyle.apply(to: font)
    }
    
    if let color = textStyle.color {
      textColor = color
    }
    
    if let alignment = textStyle.alignment {
      textAlignment = alignment
    }
  }

  func setTextStyle2(_ textStyle: TextStyle2) {
    if let fontStyle = textStyle.fontStyle {
      font = fontStyle.apply(to: font)
    }

    if let color = textStyle.color {
      textColor = color.uiColor
    }

    if let alignment = textStyle.alignment {
      textAlignment = alignment.nsTextAlignment
    }
  }
}
