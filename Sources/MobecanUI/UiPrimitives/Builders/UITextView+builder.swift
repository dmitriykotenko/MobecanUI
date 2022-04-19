// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UITextView {
  
  @discardableResult
  func textStyle(_ textStyle: TextStyle) -> Self {
    setTextStyle(textStyle)
    return self
  }
  
  @discardableResult
  func textContainerInset(_ textContainerInset: UIEdgeInsets) -> Self {
    self.textContainerInset = textContainerInset
    return self
  }
  
  @discardableResult
  func lineFragmentPadding(_ lineFragmentPadding: CGFloat) -> Self {
    self.textContainer.lineFragmentPadding = lineFragmentPadding
    return self
  }
  
  @discardableResult
  func keyboard(_ keyboardType: UIKeyboardType) -> Self {
    self.keyboardType = keyboardType
    return self
  }
  
  @discardableResult
  func autocapitalization(_ autocapitalizationType: UITextAutocapitalizationType) -> Self {
    self.autocapitalizationType = autocapitalizationType
    return self
  }
  
  @discardableResult
  func autocorrection(_ autocorrectionType: UITextAutocorrectionType) -> Self {
    self.autocorrectionType = autocorrectionType
    return self
  }
}
