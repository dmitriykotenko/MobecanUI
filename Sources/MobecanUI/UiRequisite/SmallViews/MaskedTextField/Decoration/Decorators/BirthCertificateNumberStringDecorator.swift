/// Decorates a number of russian birth certificate entered by the user – to make the number more human-readable.
class BirthCertificateNumberStringDecorator: StringDecorator {
  
  private struct Sections {
    var romanDigits: String
    var letters: String
    var remainder: String
  }
  
  func decorate(_ string: String) -> DecoratedString {
    let sections = splitIntoSections(string)
    
    /// Roman digits go first.
    var characters = sections.romanDigits.map(significant)
    
    /// If there is at least one roman digit, we should append a space.
    if !sections.romanDigits.isEmpty && (!sections.letters.isEmpty || !sections.remainder.isEmpty) {
      characters.append(insignificant(" "))
    }
    
    // Cyrillic letters go second.
    characters += sections.letters.map(significant)
    
    // If there are exactly two cyrillic letters, we should append a space.
    if sections.letters.count >= 2 {
      characters.append(insignificant(" "))
    }
    
    // Remainder goes last.
    characters += sections.remainder.map(significant)
    
    return DecoratedString(characters: characters)
  }
  
  private func splitIntoSections(_ string: String) -> Sections {
    let romanDigits = string.prefix(while: isRomanDigit)
    
    let letters = string
      .drop(while: isRomanDigit)
      .prefix(while: isCyrillicLetter)
    
    let remainder = string
      .drop(while: isRomanDigit)
      .drop(while: isCyrillicLetter)
    
    return Sections(
      romanDigits: String(romanDigits),
      letters: String(letters),
      remainder: String(remainder)
    )
  }
  
  private func isRomanDigit(_ character: Character) -> Bool {
    return String.romanDigits.contains(character)
  }
  
  private func isCyrillicLetter(_ character: Character) -> Bool {
    return String.cyrillicLetters.contains(character)
  }
  
  private func significant(_ character: Character) -> DecoratedCharacter {
    return DecoratedCharacter(
      character: character,
      isSignificant: true
    )
  }
  
  private func insignificant(_ character: Character) -> DecoratedCharacter {
    return DecoratedCharacter(
      character: character,
      isSignificant: false
    )
  }
}
