class TimeStringDecorator: StringDecorator {
  
  func decorate(_ string: String) -> DecoratedString {
    var decoratedCharacters = string.map {
      DecoratedCharacter(character: $0, isSignificant: true)
    }
    
    if decoratedCharacters.count > 2 {
      let colon = DecoratedCharacter(character: ":", isSignificant: false)
      decoratedCharacters.insert(colon, at: 2)
    }
    
    return DecoratedString(characters: decoratedCharacters)
  }
}
