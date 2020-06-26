//  Copyright © 2019 Mobecan. All rights reserved.

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
}
