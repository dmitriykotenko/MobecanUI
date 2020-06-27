/// Checks if a string is good or bad.
public protocol StringValidator {
  
  /// Returns true if given string is good.
  func isValid(_ string: String) -> Bool
}


struct FunctionStringValidator: StringValidator {
  
  let function: (String) -> Bool
  
  func isValid(_ string: String) -> Bool {
    return function(string)
  }
}
