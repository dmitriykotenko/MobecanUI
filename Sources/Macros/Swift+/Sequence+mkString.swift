// Copyright © 2024 Mobecan. All rights reserved.


extension Sequence {

  func mkStringWithSpace(start: String = "",
                         end: String = "") -> String {
    mkString(start: start, separator: " ", end: end)
  }

  func mkStringWithComma(start: String = "",
                         end: String = "") -> String {
    mkString(start: start, separator: ", ", end: end)
  }

  func mkStringWithColon(start: String = "",
                         end: String = "") -> String {
    mkString(start: start, separator: ": ", end: end)
  }

  func mkStringWithCommaAndNewLine(start: String = "",
                                   end: String = "") -> String {
    mkString(start: start, separator: ",\n", end: end)
  }

  func mkStringWithNewLine(start: String = "",
                           end: String = "") -> String {
    mkString(start: start, separator: "\n", end: end)
  }

  func mkStringWithNewParagraph(start: String = "",
                                end: String = "") -> String {
    mkString(start: start, separator: "\n\n", end: end)
  }

  func mkString(start: String = "",
                separator: String = "",
                end: String = "") -> String {
    start + map { "\($0)" }.joined(separator: separator) + end
  }
}


extension Collection {
  
  func mkString(start: String = "",
                format: (Element) -> String,
                separator: String,
                end: String = "",
                ifEmptyReturn stringForEmptyArray: String? = nil) -> String {
    switch (stringForEmptyArray, isEmpty) {
    case (let result?, true):
      return result
    default:
      return map(format).mkString(start: start, separator: separator, end: end)
    }
  }
}
