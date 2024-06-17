// Copyright © 2024 Mobecan. All rights reserved.

import Foundation


public extension Error {

  /// Стабильное текстовое представление ошибки.
  ///
  /// Полезно в тестах, если тип ошибки неизвестен и ошибка может оказаться в том числе экземпляром NSError,
  /// и при этом доступа к самой ошибке уже нет, а есть только её текстовое описание.
  var stableDescription: String {
    type(of: self) == NSError.self ?
      (self as NSError).stableDescription :
      (self as? Codable)?.toJsonString(outputFormatting: .sortedKeys) ?? "\(self)"
  }
}
