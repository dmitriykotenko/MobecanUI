import Foundation


/// Kind of attribution for ``MaskedTextField``.
///
/// ``.none`` means no attribution, i. e. text field's text is always a plain ``String``
///
/// ``.simple`` makes sense when text field's decoration is ``TextFieldDecoration.template``,
/// it applies different attributes to template prefix, template body and template suffix
///
/// ``.characterBased`` applies different attributes to every character of text field's text
///
/// ``.custom`` means that custom attribution will be used
public enum TextFieldAttribution {

  /// Do not append attributes to text field's text.
  case none

  /// Different attributes for text field's prefix, body and suffix.
  ///
  /// Makes sense when text field's decoration is ``TextFieldDecoration.template``.
  case simple(
    prefix: [NSAttributedString.Key: Any]? = nil,
    body: [NSAttributedString.Key: Any]? = nil,
    suffix: [NSAttributedString.Key: Any]? = nil
  )

  /// Different attributes for every character.
  case characterBased((FlaggedCharacter) -> [NSAttributedString.Key: Any]?)

  /// Custom attribution for ``MaskedTextField``.
  case custom(DecoratedStringAttributor)
  
  func parse() -> DecoratedStringAttributor {
    switch self {
    case .none:
      return EmptyStringAttributor()
    case .simple(let prefix, let body, let suffix):
      return TemplateBasedStringAttributor(
        attributes: .init(
          prefix: prefix,
          body: body,
          suffix: suffix
        )
      )
    case .characterBased(let characterAttributes):
      return CharacterBasedStringAttributor(characterAttributes: characterAttributes)
    case .custom(let customAttributor):
      return customAttributor
    }
  }
}
