// Copyright © 2024 Mobecan. All rights reserved.

import Foundation


public extension String {

  func matches(forRegex regexPattern: String) -> [NSTextCheckingResult] {
    guard let regex = try? NSRegularExpression(pattern: regexPattern)
    else { return [] }

    return regex.matches(in: self, range: wholeNsRange)
  }

  func findRegex(_ regexPattern: String) -> NSTextCheckingResult? {
    let regex = try? NSRegularExpression(pattern: regexPattern)
    
    return regex?.matches(in: self, range: wholeNsRange).first
  }

  func capturedGroups(for regexPattern: String) -> [[String]] {
    matches(forRegex: regexPattern).map {
      $0.capturedGroups(in: self)
    }
  }

  func capturedGroups(forFirstMatchOf regexPattern: String) -> [String]? {
    capturedGroups(for: regexPattern).first
  }
}


public extension NSTextCheckingResult {

  func capturedGroups(in string: String) -> [String] {
    (0..<numberOfRanges).map {
      let rangeBounds = range(at: $0)
      let range = Range(rangeBounds, in: string)
      return range.map { string[$0].asString } ?? ""
    }
  }
}
