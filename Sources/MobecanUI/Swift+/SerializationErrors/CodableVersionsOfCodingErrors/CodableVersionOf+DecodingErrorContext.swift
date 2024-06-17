// Copyright © 2024 Mobecan. All rights reserved.

import Foundation


extension CodableVersionOf {

  /// Контекст произошедшей ошибки десериализации.
  ///
  /// Аналог ``Swift.DecodingError.Context``, реализующий протоколы ``Equatable``, ``Hashable`` и ``Codable``.
  public struct DecodingErrorContext: Equatable, Hashable, Codable {

    /// Полный путь к полю, которое не удалось десериализовать.
    ///
    /// Например, в JSON-объекте `{a1: [{b1: 1, b2: "2"}, {b2: "3"}, {b2: "4"}], a2: false}`
    /// путём может быть последовательность `["a1", 0, "b1"]`.
    /// Это значит, что ошибка произошла при десериализации поля a1[0].b1.
    public var codingPath: [CodableVersionOf.CodingKey]

    /// Подробности произошедшей ошибки, полезные при отладке.
    public var debugDescription: String?

    /// Какая-то другая ошибка, которая является настоящей причиной ошибки десериализации.
    public var underlyingError: String?

    /// Конвертирует ``Swift.DecodingError.Context`` в ``CodableVersionOf.DecodingErrorContext``.
    public init(_ origin: Swift.DecodingError.Context) {
      codingPath = origin.codingPath.map(\.asCodableValue)
      debugDescription = origin.debugDescription
      underlyingError = origin.underlyingError?.stableDescription
    }

    public init(codingPath: [CodableVersionOf.CodingKey],
                debugDescription: String?,
                underlyingError: String? = nil) {
      self.codingPath = codingPath
      self.debugDescription = debugDescription
      self.underlyingError = underlyingError
    }

    public static let empty = DecodingErrorContext(codingPath: [], debugDescription: nil)
  }
}


public extension DecodingError.Context {

  /// Конвертирует ``Swift.DecodingError.Context`` в ``CodableVersionOf.DecodingErrorContext``.
  var asCodableValue: CodableVersionOf.DecodingErrorContext {
    .init(self)
  }
}
