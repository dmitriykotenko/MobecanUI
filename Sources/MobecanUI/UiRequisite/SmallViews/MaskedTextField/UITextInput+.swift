import UIKit


extension UITextInput {
  
  var selectedUtf16range: NSRange? {
    guard let range = selectedTextRange else { return nil }
    
    let location = offset(from: beginningOfDocument, to: range.start)
    let length = offset(from: range.start, to: range.end)
    
    return NSRange(location: location, length: length)
  }

  func setCaretOffset(_ offset: Int) {
    if let newCaretPosition = position(from: beginningOfDocument, offset: offset) {
      moveCaret(to: newCaretPosition)
    }
  }

  func moveCaret(to newPosition: UITextPosition) {
    selectedTextRange = textRange(from: newPosition, to: newPosition)
  }
}
