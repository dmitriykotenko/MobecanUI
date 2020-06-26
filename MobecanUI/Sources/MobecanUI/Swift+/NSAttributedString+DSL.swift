//  Copyright © 2019 Mobecan. All rights reserved.

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
    return NSAttributedString(string: string)
  }
}
