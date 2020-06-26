//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UITextField {
  
  func placeholder(_ placeholder: String?) -> Self {
    self.placeholder = placeholder
    return self
  }
  
  func clearButtonMode(_ clearButtonMode: UITextField.ViewMode) -> Self {
    self.clearButtonMode = clearButtonMode
    return self
  }
  
  func textStyle(_ textStyle: TextStyle) -> Self {
    setTextStyle(textStyle)
    return self
  }

  func keyboard(_ keyboardType: UIKeyboardType) -> Self {
    self.keyboardType = keyboardType
    return self
  }
  
  func returnKeyType(_ returnKeyType: UIReturnKeyType) -> Self {
    self.returnKeyType = returnKeyType
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
