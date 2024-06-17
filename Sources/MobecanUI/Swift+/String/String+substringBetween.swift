// Copyright © 2024 Mobecan. All rights reserved.

import Foundation


public extension String {

  /// Подстрока между первым ``startSeparator``
  /// и первым ``endSeparator``, идущим после первого ``startSeparator``.
  ///
  /// Например:
  /// ```
  /// "abc".substring(between: "a", and: "c") == "b"
  /// "abccc".substring(between: "a", and: "c") == "b"
  /// "aaabccc".substring(between: "a", and: "c") == "aab"
  /// ```
  ///
  /// - Note: Если в строке нет ``startSeparator`` или ``endSeparator``, возвращает `nil`.
  ///
  /// - Note: Если после первого ``startSeparator`` нет ни одного ``endSeparator``, тоже возвращает `nil`.
  func substring(between startSeparator: String,
                 and endSeparator: String) -> Substring? {
    let startRange = range(of: startSeparator)

    let endRange = startRange.flatMap {
      range(of: endSeparator, onlyAfter: $0.upperBound)
    }

    return zip(startRange, endRange).map {
      self[$0.upperBound..<$1.lowerBound]
    }
  }

  /// Подстрока между первым ``startSeparator``
  /// и последним ``endSeparator``.
  ///
  /// Например:
  /// ```
  /// "abc".substring(betweenFirst: "a", andLast: "c") == "b"
  /// "abccc".substring(betweenFirst: "a", andLast: "c") == "bcc"
  /// "aaabccc".substring(betweenFirst: "a", andLast: "c") == "aabcc"
  /// ```
  ///
  /// - Note: Если в строке нет ``startSeparator`` или ``endSeparator``, возвращает `nil`.
  ///
  /// - Note: Если после первого ``startSeparator`` нет ни одного ``endSeparator``, тоже возвращает `nil`.
  func substring(betweenFirst startSeparator: String,
                 andLast endSeparator: String) -> Substring? {
    let startRange = range(of: startSeparator)

    let endRange = startRange.flatMap {
      range(of: endSeparator, onlyAfter: $0.upperBound, options: .backwards)
    }

    return zip(startRange, endRange).map {
      self[$0.upperBound..<$1.lowerBound]
    }
  }
}
