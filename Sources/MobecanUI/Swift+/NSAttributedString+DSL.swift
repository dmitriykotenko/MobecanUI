// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension NSAttributedString {
  
  static func + (this: NSAttributedString,
                 that: NSAttributedString) -> NSAttributedString {
    let sum = NSMutableAttributedString()
    
    sum.append(this)
    sum.append(that)
    
    return sum
  }
  
  static func plain(_ string: String) -> NSAttributedString {
    NSAttributedString(string: string)
  }
  
  static func colored(_ string: String,
                      textColor: UIColor? = nil,
                      backgroundColor: UIColor? = nil) -> NSAttributedString {
    var attributes: [NSAttributedString.Key: Any] = [:]
    attributes[.foregroundColor] = textColor
    attributes[.backgroundColor] = backgroundColor
    
    return NSAttributedString(
      string: string,
      attributes: attributes
    )
  }
}
