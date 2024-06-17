// Copyright © 2021 Mobecan. All rights reserved.

import Foundation


public extension String {

  var startWithLowercaseLetter: String {
    let firstWord = split(whereSeparator: { !$0.isLetter }).first.map { String($0) }

    return
      (firstWord?.uppercased() == firstWord) ?
      self :
      prefix(1).lowercased() + dropFirst()
  }

  func without(characters: CharacterSet) -> String {
    String(
      compactMap {
        $0.belongs(to: characters) ? nil : $0
      }
    )
  }

  func prepending(_ that: any StringProtocol) -> String {
    that.asString + self
  }

  /// Если аргумент != `null`, приписывает себя к его началу.
  ///
  /// Например:
  /// ```
  /// "extension ".prependTo("Int") == "extension Int"
  /// "extension ".prependTo(nil) == nil
  /// ```
  /// - Parameter suffix: Строка, к которой надо приписать текущую строку.
  /// - Returns: `null`, если `suffix == null`, и `self + suffix!` в остальных случаях.
  func prependTo(_ suffix: String?) -> String? {
    suffix?.prepending(self)
  }

  func repeated(count: Int) -> String {
    .init(repeating: self, count: count)
  }
}
