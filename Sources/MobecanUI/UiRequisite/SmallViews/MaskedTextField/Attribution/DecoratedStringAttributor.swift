import Foundation


/// Builds ``NSAttributedString`` from ``DecoratedString``.
public protocol DecoratedStringAttributor {
  
  func attributedString(_ decoratedString: DecoratedString) -> NSAttributedString
}


struct EmptyStringAttributor: DecoratedStringAttributor {

  func attributedString(_ decoratedString: DecoratedString) -> NSAttributedString {
    .init(string: decoratedString.content)
  }
}


struct CharacterBasedStringAttributor: DecoratedStringAttributor {
  
  let characterAttributes: (FlaggedCharacter) -> [NSAttributedString.Key: Any]?

  func attributedString(_ decoratedString: DecoratedString) -> NSAttributedString {
    decoratedString.characters
      .map { $0.with(attributes: characterAttributes($0)) }
      .flattened
  }
}


struct TemplateBasedStringAttributor: DecoratedStringAttributor {

  struct Attributes {
    var prefix: [NSAttributedString.Key: Any]?
    var body: [NSAttributedString.Key: Any]?
    var suffix: [NSAttributedString.Key: Any]?
  }

  let attributes: Attributes

  func attributedString(_ decoratedString: DecoratedString) -> NSAttributedString {
    let suffix = decoratedString.characters.suffix { $0.isInsignificant(caretGravity: .toBeginning) }
    let prefix = decoratedString.characters.dropLast(suffix.count).prefix { $0.isInsignificant }
    let body = decoratedString.characters.dropFirst(prefix.count).dropLast(suffix.count)

    return [
      prefix.with(attributes: attributes.prefix),
      body.with(attributes: attributes.body),
      suffix.with(attributes: attributes.suffix)
    ]
    .flattened
  }

  private func apply(attributes: [NSAttributedString.Key: Any]?,
                     to characters: [FlaggedCharacter]) -> [NSAttributedString] {
    characters.map { NSAttributedString(string: String($0.value), attributes: attributes) }
  }
}


private extension Sequence where Element == FlaggedCharacter {

  func with(attributes: [NSAttributedString.Key: Any]?) -> NSAttributedString {
    map { $0.with(attributes: attributes) }.flattened
  }
}


private extension FlaggedCharacter {

  func with(attributes: [NSAttributedString.Key: Any]?) -> NSAttributedString {
    NSAttributedString(string: String(value), attributes: attributes)
  }
}


private extension Sequence where Element == NSAttributedString {

  var flattened: NSAttributedString {
    reduce(NSMutableAttributedString()) { $0.append($1); return $0 }
  }
}


private extension Sequence {

  func suffix(while condition: (Element) throws -> Bool) rethrows -> [Self.Element] {
    try reversed().prefix(while: condition).reversed()
  }
}
