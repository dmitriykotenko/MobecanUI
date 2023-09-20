import Foundation


/// A string with every character marked as significant or not significant.
public struct DecoratedString {

  public let characters: [FlaggedCharacter]

  public init(characters: [FlaggedCharacter]) {
    self.characters = characters
  }

  public var content: String {
    String(characters.map(\.value))
  }

  public var significantContent: String {
    String(characters.filter(\.isSignificant).map(\.value))
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
    characters.prefix(upTo: index).filter(\.isSignificant).count
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

  public func indexOfLastCharacter(where condition: (FlaggedCharacter) -> Bool,
                                   before targetIndex: Int) -> Int? {
    characters.prefix(upTo: targetIndex).lastIndex(where: condition)
  }

  public func indexOfFirstCharacter(where condition: (FlaggedCharacter) -> Bool,
                                    after targetIndex: Int) -> Int? {
    characters
      .suffix(from: targetIndex)
      .dropFirst()
      .firstIndex(where: condition)
  }

  public func indexOfFirstCharacter(where condition: (FlaggedCharacter) -> Bool,
                                    startingAt targetIndex: Int) -> Int? {
    characters
      .suffix(from: targetIndex)
      .firstIndex(where: condition)
  }

  public var indexOfFirstSignificantCharacter: Int? {
    characters.firstIndex(where: \.isSignificant)
  }

  public var indexOfLastSignificantCharacter: Int? {
    characters.lastIndex(where: \.isSignificant)
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

      utf16length += String([character.value]).utf16.count
    }

    return characters.count
  }

  func utf16indexFromIndex(_ index: Int) -> Int {
    let charactersBeforeIndex = characters.prefix(upTo: index)

    return String(charactersBeforeIndex.map(\.value)).utf16.count
  }

  func utf16indexFromSignificantIndex(_ significantIndex: Int) -> Int {
    let significantCharactersBeforeIndex =
      characters.filter(\.isSignificant).prefix(upTo: significantIndex)

    return String(significantCharactersBeforeIndex.map(\.value)).utf16.count
  }
}
