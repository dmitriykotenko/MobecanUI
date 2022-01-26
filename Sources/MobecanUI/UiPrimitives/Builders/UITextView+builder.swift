// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UITextView {
  
  func textStyle(_ textStyle: TextStyle) -> Self {
    setTextStyle(textStyle)
    return self
  }
  
  func textContainerInset(_ textContainerInset: UIEdgeInsets) -> Self {
    self.textContainerInset = textContainerInset
    return self
  }
  
  func lineFragmentPadding(_ lineFragmentPadding: CGFloat) -> Self {
    self.textContainer.lineFragmentPadding = lineFragmentPadding
    return self
  }
  
  func keyboard(_ keyboardType: UIKeyboardType) -> Self {
    self.keyboardType = keyboardType
    return self
  }
  
  func autocapitalization(_ autocapitalizationType: UITextAutocapitalizationType) -> Self {
    self.autocapitalizationType = autocapitalizationType
    return self
  }
  
  func autocorrection(_ autocorrectionType: UITextAutocorrectionType) -> Self {
    self.autocorrectionType = autocorrectionType
    return self
  }
}
