import Foundation


/// A string with every character marked as significant or not significant.
public struct DecoratedString {
  
  private let characters: [DecoratedCharacter]
  
  public init(characters: [DecoratedCharacter]) {
    self.characters = characters
  }
  
  public var value: String {
    return String(characters.map { $0.character })
  }
  
  public var significantValue: String {
    let significantCharacters =
      characters.filter { $0.isSignificant }.map { $0.character }
    
    return String(significantCharacters)
  }
  
  public func isCharacterSignificant(at index: Int) -> Bool {
    if index < characters.count {
      return characters[index].isSignificant
    } else {
      return false
    }
  }
  
  public func significantRange(from range: NSRange) -> NSRange {
    let significantStart = significantIndex(from: range.location)
    let significantEnd = significantIndex(from: range.location + range.length)
    
    return NSRange(location: significantStart, length: significantEnd - significantStart)
  }
  
  private func significantIndex(from index: Int) -> Int {
    let charactersToTheLeft = characters.prefix(upTo: index)
    
    let significantCharactersToTheLeft = charactersToTheLeft.filter { $0.isSignificant }
    
    let significantIndex = significantCharactersToTheLeft.count
    
    return significantIndex
  }
  
  public func index(from significantIndex: Int) -> Int {
    var numberOfSignificantCharacters = 0
    
    for characterIndex in characters.indices {
      if numberOfSignificantCharacters == significantIndex && isCharacterSignificant(at: characterIndex) {
        return characterIndex
      }
      
      if isCharacterSignificant(at: characterIndex) {
        numberOfSignificantCharacters += 1
      }
    }
    
    return characters.count
  }
  
  public func indexOfFirstSignificantCharacter(toTheLeftFrom index: Int) -> Int? {
    let charactersToTheLeft = characters.prefix(upTo: index).enumerated().reversed()
    
    for (index, character) in charactersToTheLeft where character.isSignificant {
      return index
    }
    
    return nil
  }
  
  public func indexOfFirstSignificantCharacter(toTheRightFrom targetIndex: Int) -> Int? {
    let charactersToTheRight = characters.suffix(from: targetIndex)
    
    return charactersToTheRight.firstIndex { $0.isSignificant }
  }
}


public extension DecoratedString {
  
  func significantUtf16range(from significantRange: NSRange) -> NSRange {
    let utf16start = utf16indexFromSignificantIndex(significantRange.location)
    let utf16end = utf16indexFromSignificantIndex(significantRange.location + significantRange.length)
    
    return NSRange(location: utf16start, length: utf16end - utf16start)
  }
  
  func rangeFromUtf16Range(_ utf16range: NSRange) -> NSRange {
    let start = indexFromUtf16index(utf16range.location)
    let end = indexFromUtf16index(utf16range.location + utf16range.length)
    
    return NSRange(location: start, length: end - start)
  }
  
  func indexFromUtf16index(_ utf16index: Int) -> Int {
    var utf16length = 0
    
    for (index, character) in characters.enumerated() {
      if utf16length == utf16index {
        return index
      }
      
      utf16length += String([character.character]).utf16.count
    }
    
    return characters.count
  }
  
  func utf16indexFromIndex(_ index: Int) -> Int {
    let charactersToTheLeft = characters.prefix(upTo: index)
    
    return String(charactersToTheLeft.map { $0.character }).utf16.count
  }
  
  func utf16indexFromSignificantIndex(_ significantIndex: Int) -> Int {
    let significantCharactersToTheLeft = characters.filter { $0.isSignificant }.prefix(upTo: significantIndex)
    
    return String(significantCharactersToTheLeft.map { $0.character }).utf16.count
  }
  
}


// A character marked as significant or not significant.
public struct DecoratedCharacter {
  
  public let character: Character
  public let isSignificant: Bool
    
  public static func significant(_ character: Character) -> DecoratedCharacter {
    return DecoratedCharacter(
      character: character,
      isSignificant: true
    )
  }
  
  public static func insignificant(_ character: Character) -> DecoratedCharacter {
    return DecoratedCharacter(
      character: character,
      isSignificant: false
    )
  }
}
