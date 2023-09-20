import UIKit


/// Automatically places auxiliary characters during editing of ``MaskedTextField``.
class TextFieldDecorationEngine: TextFieldDelegateProxy {

  private weak var textField: MaskedTextField?
  private var userIntentRecognizer: UserIntentRecognizer

  private var decoratedText: DecoratedString? { textField?.decoratedText }

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
    TextReplacementOperation(
      rangeToBeReplaced: significantRange(from: replacement.rangeToBeReplaced),
      replacementString: replacement.replacementString
    )
  }

  private func significantRange(from range: NSRange) -> NSRange {
    decoratedText?.significantRange(from: range) ?? range
  }

  private func performEmptyReplacement() {
    if let currentRange = textField?.selectedTextRange {
      textField?.moveCaret(to: currentRange.start)
    }
  }

  /// Asks text field's delegate whether we need to perform text replacement.
  private func shouldPerformReplacement(_ replacement: TextReplacementOperation) -> Bool {
    guard
      let textField,
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

    guard let textField else { return }

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
    decoratedText?.significantUtf16range(from: significantRange) ?? significantRange
  }

  /// Moves the caret to desired position after the text replacement is complete.
  private func adjustCaretPosition(after replacement: TextReplacementOperation) {
    guard let decoratedText else { return }

    let significantRangeEnd = replacement.rangeToBeReplaced.location + replacement.replacementString.count
    let decoratedRangeEnd = decoratedText.index(from: significantRangeEnd)

    placeCaretAfter(
      characterIndex: decoratedText.indexOfLastCharacter(
        where: \.isSignificant,
        before: decoratedRangeEnd
      )
    )
  }

  override func textFieldDidBeginEditing(_ textField: UITextField) {
    super.textFieldDidBeginEditing(textField)

    DispatchQueue.main.async { [weak self] in
      self?.fixCaretPositionIfNecessary()
    }
  }

  private func fixCaretPositionIfNecessary() {
    guard let textField, let decoratedText else { return }

    let caretOffset = textField.selectedUtf16range?.upperBound ?? 0

    let utf16LastSignificantCharacterIndex = decoratedText.utf16indexFromIndex(
      decoratedText.indexOfLastSignificantCharacter ?? 0
    )

    if caretOffset >= utf16LastSignificantCharacterIndex {
      placeCaretAfter(characterIndex: decoratedText.indexOfLastSignificantCharacter)
    }
  }

  private func placeCaretAfter(characterIndex: Int?) {
    guard let decoratedText else { return }

    let indexOfStopCharacter = decoratedText.indexOfFirstCharacter(
      where: { $0.isSignificant || $0.isInsignificant(caretGravity: .toBeginning) },
      startingAt: characterIndex.map { $0 + 1 } ?? 0
    )

    let desiredCaretOffset = indexOfStopCharacter ?? decoratedText.content.count
    let utf16DesiredCaretOffset = decoratedText.utf16indexFromIndex(desiredCaretOffset)

    textField?.setCaretOffset(utf16DesiredCaretOffset)
  }
}
