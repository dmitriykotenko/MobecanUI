// Copyright © 2021 Mobecan. All rights reserved.

import Foundation


public extension StringProtocol {

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

  var trimmingCurlyBraces: String {
    trimmingCharacters(in: .init(charactersIn: "{}"))
  }
}
