// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UITextField {
  
  @discardableResult
  func placeholder(_ placeholder: String?) -> Self {
    self.placeholder = placeholder
    return self
  }

  @discardableResult
  func attributedPlaceholder(_ attributedPlaceholder: NSAttributedString?) -> Self {
    self.attributedPlaceholder = attributedPlaceholder
    return self
  }

  @discardableResult
  func clearButtonMode(_ clearButtonMode: UITextField.ViewMode) -> Self {
    self.clearButtonMode = clearButtonMode
    return self
  }
  
  @discardableResult
  func textStyle(_ textStyle: TextStyle) -> Self {
    setTextStyle(textStyle)
    return self
  }

  @discardableResult
  func textStyle2(_ textStyle: TextStyle2) -> Self {
    setTextStyle2(textStyle)
    return self
  }

  @discardableResult
  func keyboard(_ keyboardType: UIKeyboardType) -> Self {
    self.keyboardType = keyboardType
    return self
  }
  
  @discardableResult
  func returnKeyType(_ returnKeyType: UIReturnKeyType) -> Self {
    self.returnKeyType = returnKeyType
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
