// Copyright © 2024 Mobecan. All rights reserved.

import Foundation


public extension NSError {

  /// Стабильное текстовое представление ошибки.
  ///
  /// Полезно в тестах при сравнении NSError, конвертированных в строку
  /// (иногда нет доступа к самому NSError, а есть только его текстовое представление).
  var stableDescription: String {
    [
      "Code: \(code)",
      "Domain: \(domain)",
      stableUserInfoDescription
    ]
    .filterNil()
    .mkStringWithNewLine()
  }

  /// Стабильное текстовое представление свойства ``userInfo``.
  ///
  /// Полезно в тестах при сравнении NSError, конвертированных в строку
  /// (иногда нет доступа к самому NSError, а есть только его текстовое представление).
  var stableUserInfoDescription: String {
    "User info: "
      .prependTo(
        sortedUserInfo
          .map { "\($0.key) = \($0.value)" }
          .mkString(separator: ", ")
          .notBlankOrNil
      )
      ?? "No user info"
  }

  /// ``userInfo``, отсортированный по названиям ключей.
  var sortedUserInfo: [(key: String, value: Any)] {
    userInfo.sorted {
      $0.key <= $1.key
    }
  }
}
