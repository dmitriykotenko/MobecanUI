import UIKit


/// Automatically places auxiliary characters during editing of a text field.
class TextFieldDecorationEngine: TextFieldDelegateProxy {
  
  private weak var textField: MaskedTextField?
  private var userIntentRecognizer: UserIntentRecognizer
  
  init(textField: MaskedTextField) {
    self.textField = textField
    
    userIntentRecognizer = UserIntentRecognizer(textField: textField)
  }
  
  override func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
    
    let userIntent = TextReplacementOperation(
      rangeToBeReplaced: range,
      replacementString: string
    )
    
    let replacement = userIntentRecognizer.recognize(intent: userIntent)
    
    performReplacement(replacement)
    
    return false
  }
  
  private func performReplacement(_ replacement: TextReplacementOperation) {
    let significantReplacement = convertToSignificantReplacement(replacement)
    
    if significantReplacement.isEmpty {
      performEmptyReplacement()
    } else {
      if shouldPerformReplacement(significantReplacement) {
        performSignificantReplacement(significantReplacement)
      }
    }
  }
  
  private func convertToSignificantReplacement(_ replacement: TextReplacementOperation) -> TextReplacementOperation {
    return TextReplacementOperation(
      rangeToBeReplaced: significantRange(from: replacement.rangeToBeReplaced),
      replacementString: replacement.replacementString
    )
  }
  
  private func significantRange(from range: NSRange) -> NSRange {
    if let decoratedText = decoratedText {
      return decoratedText.significantRange(from: range)
    } else {
      return range
    }
  }
  
  private func performEmptyReplacement() {
    if let currentRange = textField?.selectedTextRange {
      moveCaret(to: currentRange.start)
    }
  }
  
  /// Asks text field's delegate whether we need to perform text replacement.
  private func shouldPerformReplacement(_ replacement: TextReplacementOperation) -> Bool {
    guard
      let textField = textField,
      let method = parent?.textField(_:shouldChangeCharactersIn:replacementString:)
      else { return true }
    
    // UITextFieldDelegate uses UTF-16-based offsets for range.
    // Hence we must convert corrected range back to UTF-16-based format.
    return method(
      textField,
      significantUtf16range(from: replacement.rangeToBeReplaced),
      replacement.replacementString
    )
  }
  
  private func performSignificantReplacement(_ replacement: TextReplacementOperation) {
    assert(!replacement.isEmpty)
    
    guard let textField = textField else { return }
    
    let currentText = textField.text ?? ""
    
    let newText = NSString(string: currentText)
      .replacingCharacters(
        in: significantUtf16range(from: replacement.rangeToBeReplaced),
        with: replacement.replacementString
      )
      .description
    
    textField.userDidChangeText(to: newText)
    
    adjustCaretPosition(after: replacement)
  }
  
  private func significantUtf16range(from significantRange: NSRange) -> NSRange {
    if let decoratedText = decoratedText {
      return decoratedText.significantUtf16range(from: significantRange)
    } else {
      return significantRange
    }
  }
  
  /// Moves the caret to desired position after the text replacement is complete.
  private func adjustCaretPosition(after replacement: TextReplacementOperation) {
    guard let decoratedText = decoratedText else { return }
    
    let significantRangeEnd = replacement.rangeToBeReplaced.location + replacement.replacementString.count
    let decoratedRangeEnd = decoratedText.index(from: significantRangeEnd)
    
    let indexOfNextSignificantCharacter = decoratedText.indexOfFirstSignificantCharacter(
      toTheRightFrom: decoratedRangeEnd
    )
    
    let desiredCaretOffset = indexOfNextSignificantCharacter ?? decoratedText.value.count
    let utf16DesiredCaretOffset = decoratedText.utf16indexFromIndex(desiredCaretOffset)
    
    setCaretPosition(offset: utf16DesiredCaretOffset)
  }
  
  private func setCaretPosition(offset: Int) {
    guard let textField = textField else { return }
    
    if let desiredCaretPosition = textField.position(from: textField.beginningOfDocument, offset: offset) {
      moveCaret(to: desiredCaretPosition)
    }
  }
  
  private func moveCaret(to desiredCaretPosition: UITextPosition) {
    guard let textField = textField else { return }
    
    textField.selectedTextRange = textField.textRange(
      from: desiredCaretPosition,
      to: desiredCaretPosition
    )
  }
  
  private var decoratedText: DecoratedString? {
    return textField?.decoratedText
  }
}
