import UIKit


/// A helper to fix a couple of things broken by ``TextFieldDecorationEngine``.
class TextFieldSurgeon: TextFieldDelegateProxy {
  
  /// ``TextFieldDecorationEngine`` breaks the behavior of UITextField's system 'Clear' button.
  /// To fix it, we need to explicitly clear the text field once the user presses the button.
  override func textFieldShouldClear(_ textField: UITextField) -> Bool {
    let shouldClear = parent?.textFieldShouldClear?(textField) ?? true
    let maskedTextField = textField as? MaskedTextField
    
    if shouldClear {
      maskedTextField?.userDidChangeText(to: "")
    }
    
    return false
  }
  
  /// Hides the keyboard when the user presses “Return” button.
  override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let textFieldShouldReturnMethod = parent?.textFieldShouldReturn(_:) {
      // If the parent has its own logic for hiding the keyboard, we should not do anything.
      return textFieldShouldReturnMethod(textField)
    } else {
      // If the parent has not implemented textFieldShouldReturn(_:) method, we should hide the keyboard.
      textField.resignFirstResponder()
      
      return true
    }
  }
}
