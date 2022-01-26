// Copyright © 2021 Mobecan. All rights reserved.

import Foundation
import CoreGraphics


public extension Character {

  func belongs(to set: CharacterSet) -> Bool {
    set.contains(character: self)
  }
}
