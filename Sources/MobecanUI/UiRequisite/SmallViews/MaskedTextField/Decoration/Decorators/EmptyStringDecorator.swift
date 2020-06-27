class EmptyStringDecorator: StringDecorator {
  
  func decorate(_ string: String) -> DecoratedString {
    let decoratedCharacters = string.map {
      DecoratedCharacter(character: $0, isSignificant: true)
    }
    
    return DecoratedString(characters: decoratedCharacters)
  }
}
