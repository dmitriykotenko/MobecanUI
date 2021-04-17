//  Copyright © 2021 Mobecan. All rights reserved.

import Foundation
import CoreGraphics


public extension String {

  func trimmingLeadingCharacters(in set: CharacterSet) -> String {
    String(
      drop(while: set.contains(character:))
    )
  }

  func trimmingTrailingCharacters(in set: CharacterSet) -> String {
    String(
      dropLastWhile(set.contains(character:))
    )
  }

  var trimmingBlanks: String {
    trimmingCharacters(in: .whitespacesAndNewlines)
  }
}
