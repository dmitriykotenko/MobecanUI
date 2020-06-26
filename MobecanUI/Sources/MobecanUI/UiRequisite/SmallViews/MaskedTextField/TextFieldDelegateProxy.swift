import UIKit


/// Intermediate delegate for a text field.
///
/// Simplifies the creation of chains of text field delegates.
class TextFieldDelegateProxy: NSObject, UITextFieldDelegate {
  
  var parent: UITextFieldDelegate?
  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    
    if let stringReplacementMethod = parent?.textField(_:shouldChangeCharactersIn:replacementString:) {
      return stringReplacementMethod(textField, range, string)
    } else {
      return true
    }
  }

  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if let textFieldShouldBeginEditingMethod = parent?.textFieldShouldBeginEditing(_:) {
      return textFieldShouldBeginEditingMethod(textField)
    } else {
      return true
    }
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if let textFieldDidBeginEditingMethod = parent?.textFieldDidBeginEditing(_:) {
      textFieldDidBeginEditingMethod(textField)
    }
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if let textFieldShouldEndEditingMethod = parent?.textFieldShouldEndEditing(_:) {
      return textFieldShouldEndEditingMethod(textField)
    } else {
      return true
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if let textFieldDidEndEditingMethod = parent?.textFieldDidEndEditing(_:) {
      textFieldDidEndEditingMethod(textField)
    }
  }
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    if let textFieldShouldClearMethod = parent?.textFieldShouldClear(_:) {
      return textFieldShouldClearMethod(textField)
    } else {
      return true
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let textFieldShouldReturnMethod = parent?.textFieldShouldReturn(_:) {
      return textFieldShouldReturnMethod(textField)
    } else {
      return true
    }
  }
}


extension TextFieldDelegateProxy {
  
  var askParent: (_ textField: UITextField,
    _ range: NSRange,
    _ replacementString: String) -> Bool {
    
    let parentMethod = parent?.textField(_:shouldChangeCharactersIn:replacementString:)
    
    return parentMethod ?? alwaysAllow
  }
  
  private var alwaysAllow: (_ textField: UITextField,
    _ range: NSRange,
    _ replacementString: String) -> Bool {
    return { _, _, _ in true }
  }
}
