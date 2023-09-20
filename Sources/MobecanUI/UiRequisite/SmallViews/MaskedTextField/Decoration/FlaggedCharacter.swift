import Foundation


/// A character marked as significant or not significant.
public enum FlaggedCharacter {

  /// Which side to put the caret on if we want to place the caret near the character.
  ///
  /// Used by ``TextFieldDecorationEngine`` to adjust caret position after user input.
  public enum CaretGravity {

    /// Place the caret before the character.
    case toBeginning

    /// Place the caret after the character.
    case toEnd
  }

  case significant(Character)
  case insignificant(Character, caretGravity: CaretGravity)

  public static func insignificant(_ character: Character) -> Self {
    .insignificant(character, caretGravity: .toEnd)
  }

  public var value: Character {
    switch self {
    case .significant(let character):
      return character
    case .insignificant(let character, _):
      return character
    }
  }

  public var isSignificant: Bool {
    switch self {
    case .significant:
      return true
    case .insignificant:
      return false
    }
  }

  public var isInsignificant: Bool { !isSignificant }

  public func isInsignificant(caretGravity: CaretGravity) -> Bool {
    switch self {
    case .significant:
      return false
    case .insignificant(_, let selfCaretGravity):
      return selfCaretGravity == caretGravity
    }
  }
}
