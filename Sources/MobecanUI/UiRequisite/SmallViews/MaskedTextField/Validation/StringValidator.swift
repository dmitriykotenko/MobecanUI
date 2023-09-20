/// Checks if a text change is good or bad.
///
/// It is recommended to always consider a text change as good
/// in case ``TextChange.replacementString`` is empty.
/// Otherwise, users can be accidentally unable to delete unwanted characters
/// by pressing 'Backspace' key.
public protocol StringValidator {
  
  /// Returns true if given string is good.
  func isValid(_ change: TextChange) -> Bool
}


struct FunctionStringValidator: StringValidator {
  
  let function: (TextChange) -> Bool
  
  init(function: @escaping (TextChange) -> Bool) {
    self.function = function
  }
  
  func isValid(_ change: TextChange) -> Bool {
    function(change)
  }
}
