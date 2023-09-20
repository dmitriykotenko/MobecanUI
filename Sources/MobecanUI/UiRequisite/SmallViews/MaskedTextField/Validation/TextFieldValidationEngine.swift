import UIKit


/// Validates any value before it becomes text field's text.
///
/// If the value is invalid, does not allow to perform an update.
class TextFieldValidationEngine: TextFieldDelegateProxy {
  
  var validator: StringValidator = FunctionStringValidator { _ in true }
  
  override init() {
    super.init()
  }
  
  override func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
    let textChange = TextChange(
      oldText: textField.text,
      replacementRange: range,
      replacementString: string
    )
    
    if validator.isValid(textChange) {
      return askParent(textField, range, string)
    } else {
      // If new value is not valid, do not allow to use it.
      return false
    }
  }
}
