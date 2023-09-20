class TemplateStringDecorator: StringDecorator {
  
  private static let defaultPlaceholder = "_"
  
  private var template: String
  private var prefix: [FlaggedCharacter]
  private var bodySuffixes: [String]
  private var globalSuffix: [FlaggedCharacter]
  
  init(template: String,
       globalSuffix: String? = nil,
       placeholder: String = defaultPlaceholder) {
    let characterGroups = template.components(separatedBy: placeholder)
    
    self.template = template
    self.prefix = characterGroups[0].map { .insignificant($0) }
    self.globalSuffix = globalSuffix?.map { .insignificant($0, caretGravity: .toBeginning) } ?? []

    bodySuffixes = Array(characterGroups.dropFirst())
  }
  
  func decorate(_ string: String) -> DecoratedString {
    DecoratedString(
      characters: [prefix, decorateBody(of: string), globalSuffix].flatMap { $0 }
    )
  }

  private func decorateBody(of string: String) -> [FlaggedCharacter] {
    string.enumerated().flatMap {
      decorateCharacter($0.element, at: $0.offset)
    }
  }
  
  private func decorateCharacter(_ character: Character,
                                 at index: Int) -> [FlaggedCharacter] {
    [.significant(character)] + suffix(for: index).map { .insignificant($0) }
  }
  
  private func suffix(for index: Int) -> String {
    if index < bodySuffixes.count {
      return bodySuffixes[index]
    } else {
      return ""
    }
  }
}
