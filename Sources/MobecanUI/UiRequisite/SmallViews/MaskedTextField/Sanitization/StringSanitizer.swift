/// Removes inappropriate characters from the string.
public protocol StringSanitizer {
  
  /// Returns given string without inappropriate characters.
  func sanitize(_ string: String) -> String
}


struct FunctionStringSanitizer: StringSanitizer {

  let function: (String) -> String
  
  func sanitize(_ string: String) -> String {
    return function(string)
  }
}
