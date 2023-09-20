import Foundation


/// A request to change text field's text.
public struct TextChange {
  
  /// Text field's text before the change.
  public let oldText: String?

  /// Range to be replaced inside `oldText`.
  public let replacementRange: NSRange

  /// A string to be inserted into `oldText`.
  public let replacementString: String
  
  /// Text field's text after the change.
  public var newText: String {
    let oldNsString = (oldText ?? "") as NSString
    
    return oldNsString.replacingCharacters(
      in: replacementRange,
      with: replacementString
    )
  }
}
