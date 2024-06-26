// Copyright © 2024 Mobecan. All rights reserved.


extension Collection {

  var isNotEmpty: Bool { !isEmpty }

  func mkStringWithNewLine(start: String = "",
                           end: String = "") -> String {
    mkString(start: start, separator: "\n", end: end)
  }

  func mkString(start: String = "",
                separator: String = "",
                end: String = "") -> String {
    start + map { "\($0)" }.joined(separator: separator) + end
  }
}


extension Collection where Element: Hashable {

  var asSet: Set<Element> { .init(self) }
}
