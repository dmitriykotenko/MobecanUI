// Copyright © 2021 Mobecan. All rights reserved.

import Foundation
import NonEmpty


public extension String {

  static func random(count: Int,
                     charactersFrom possibleCharacters: NonEmptyString) -> String {
    random(
      countRange: count..<(count + 1), 
      charactersFrom: possibleCharacters
    )
  }

  static func random(countRange: Range<Int>,
                     charactersFrom possibleCharacters: NonEmptyString) -> String {
    (0..<Int.random(in: countRange))
      .map { _ in possibleCharacters.randomElement() }
      .mkString()
  }
}
