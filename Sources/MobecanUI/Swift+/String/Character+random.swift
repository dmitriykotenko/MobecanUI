// Copyright © 2021 Mobecan. All rights reserved.

import Foundation
import NonEmpty


public extension Character {

  static func random(fromString string: NonEmptyString) -> Character {
    string.randomElement()
  }
}
