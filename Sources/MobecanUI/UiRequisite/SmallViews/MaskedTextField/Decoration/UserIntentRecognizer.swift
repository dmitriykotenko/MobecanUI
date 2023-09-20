import UIKit


/// Recognizes user's intent when editing a text field.
///
/// For example, when the user taps “Backspace”, user's intent is not to erase
/// the closest character before the caret. Instead, the intent is
/// to erase the closest __significant__ character before the caret.
class UserIntentRecognizer {

  private weak var textField: MaskedTextField?

  private var decoratedText: DecoratedString? { textField?.decoratedText }

  init(textField: MaskedTextField) {
    self.textField = textField
  }

  func recognize(intent: TextReplacementOperation) -> TextReplacementOperation {
    let correctedRange = convertRangeFrom(utf16range: intent.rangeToBeReplaced)

    let correctedIntent = TextReplacementOperation(
      rangeToBeReplaced: correctedRange,
      replacementString: intent.replacementString
    )

    return expandRangeIfNecessary(correctedIntent)
  }

  private func convertRangeFrom(utf16range: NSRange) -> NSRange {
    decoratedText?.rangeFromUtf16Range(utf16range) ?? utf16range
  }

  private func expandRangeIfNecessary(_ replacement: TextReplacementOperation) -> TextReplacementOperation {
    let replacementString = replacement.replacementString
    var range = replacement.rangeToBeReplaced

    if shouldExpandRangeToClosestSignificantCharacter(replacement: replacement) {
      range = expandToClosestSignificantCharacter(range: replacement.rangeToBeReplaced)
    }

    return TextReplacementOperation(
      rangeToBeReplaced: range,
      replacementString: replacementString
    )
  }

  private func shouldExpandRangeToClosestSignificantCharacter(replacement: TextReplacementOperation) -> Bool {
    let firstReplacedCharacterIsSignificant =
      decoratedText?.isCharacterSignificant(at: replacement.rangeToBeReplaced.location)
      ?? false

    return replacement.replacementString.isEmpty
      && replacement.rangeToBeReplaced.length > 0
      && textField?.selectedUtf16range?.length == 0
      && !firstReplacedCharacterIsSignificant
  }

  private func expandToClosestSignificantCharacter(range: NSRange) -> NSRange {
    switch decoratedText?.indexOfLastCharacter(where: \.isSignificant, before: range.location) {
    case nil:
      return range
    case let closestSignificantCharacterIndex?:
      let expandedLength = range.length + (range.location - closestSignificantCharacterIndex)

      return NSRange(
        location: closestSignificantCharacterIndex,
        length: expandedLength
      )
    }
  }
}
