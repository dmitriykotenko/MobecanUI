//  Copyright © 2020 Mobecan. All rights reserved.


public extension Array {
  
  func mkStringWithNewLine(start: String = "",
                           end: String = "") -> String {
    return mkString(start: start, separator: "\n", end: end)
  }
  
  func mkString(start: String = "",
                separator: String = "",
                end: String = "") -> String {
    return
      start + map { "\($0)" }.joined(separator: separator) + end
  }
}
