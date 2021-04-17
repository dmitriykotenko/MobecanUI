//  Copyright © 2021 Mobecan. All rights reserved.

import Foundation
import CoreGraphics


public extension CharacterSet {

  func contains(character: Character) -> Bool {
    character.unicodeScalars.allSatisfy(contains)
  }
}
