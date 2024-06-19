// Copyright © 2024 Mobecan. All rights reserved.


extension String {

  func appendingToLines(of string: String) -> Self {
    string.appendingToEveryLine(self)
  }

  func appendingToEveryLine(_ prefix: any StringProtocol) -> Self {
    split(separator: "\n")
      .map { prefix + $0 }
      .mkStringWithNewLine()
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
}


extension StringProtocol {

  var asString: String { String(self) }
}
