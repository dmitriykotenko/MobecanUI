// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UILabel {
  
  @discardableResult
  func textStyle(_ textStyle: TextStyle) -> Self {
    setTextStyle(textStyle)
    return self
  }
  
  @discardableResult
  func text(_ text: String?) -> Self {
    self.text = text
    return self
  }
  
  @discardableResult
  func attributedText(_ attributedText: NSAttributedString?) -> Self {
    self.attributedText = attributedText
    return self
  }
  
  @discardableResult
  func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
    self.lineBreakMode = lineBreakMode
    return self
  }
  
  @discardableResult
  func numberOfLines(_ numberOfLines: Int) -> Self {
    self.numberOfLines = numberOfLines
    return self
  }
  
  @discardableResult
  func singlelined() -> Self {
    numberOfLines(1).lineBreakMode(.byTruncatingTail)
  }

  @discardableResult
  func multilined() -> Self {
    numberOfLines(0).lineBreakMode(.byWordWrapping)
  }
  
  @discardableResult
  func autoscaled(minimumScaleFactor: CGFloat) -> Self {
    self.adjustsFontSizeToFitWidth = true
    self.minimumScaleFactor = minimumScaleFactor
    return self
  }
}


public extension DiverseLabel {

  @discardableResult
  func textTransformer(_ transformer: StringTransformer?) -> Self {
    self.textTransformer = transformer
    return self
  }
}
