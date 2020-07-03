//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UILabel {
  
  func textStyle(_ textStyle: TextStyle) -> Self {
    setTextStyle(textStyle)
    return self
  }
  
  func text(_ text: String?) -> Self {
    self.text = text
    return self
  }
  
  func attributedText(_ attributedText: NSAttributedString?) -> Self {
    self.attributedText = attributedText
    return self
  }
  
  func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
    self.lineBreakMode = lineBreakMode
    return self
  }
  
  func numberOfLines(_ numberOfLines: Int) -> Self {
    self.numberOfLines = numberOfLines
    return self
  }
  
  func singlelined() -> Self {
    numberOfLines(1).lineBreakMode(.byTruncatingTail)
  }

  func multilined() -> Self {
    numberOfLines(0).lineBreakMode(.byWordWrapping)
  }
  
  func autoscaled(minimumScaleFactor: CGFloat) -> Self {
    self.adjustsFontSizeToFitWidth = true
    self.minimumScaleFactor = minimumScaleFactor
    return self
  }
}
