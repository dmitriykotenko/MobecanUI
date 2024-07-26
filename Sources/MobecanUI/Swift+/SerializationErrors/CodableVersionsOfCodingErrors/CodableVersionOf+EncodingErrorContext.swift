// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


extension CodableVersionOf {
  
  /// Контекст произошедшей ошибки сериализации.
  ///
  /// Аналог ``Swift.EncodingError.Context``, реализующий протоколы ``Equatable``, ``Hashable`` и ``Codable``.
  @DerivesAutoGeneratable
  public struct EncodingErrorContext: Equatable, Hashable, Codable {

    /// Полный путь к полю, которое не удалось сериализовать.
    ///
    /// Например, в объекте `class User { let name: String; let parents: [User] }`
    /// путём может быть последовательность `["parents", 0, "name"]`.
    /// Это значит, что ошибка произошла при сериализации поля parents[0].name.
    public var codingPath: [CodableVersionOf.CodingKey]

    /// Подробности произошедшей ошибки, полезные при отладке.
    public var debugDescription: String?

    /// Какая-то другая ошибка, которая является настоящей причиной ошибки сериализации.
    public var underlyingError: String?

    /// Конвертирует ``Swift.EncodingError.Context`` в ``CodableVersionOf.EncodingErrorContext``.
    public init(_ origin: Swift.EncodingError.Context) {
      codingPath = origin.codingPath.map(\.asCodableValue)
      debugDescription = origin.debugDescription
      underlyingError = origin.underlyingError.map { "\($0)" }
    }

    public init(codingPath: [CodableVersionOf.CodingKey],
                debugDescription: String?,
                underlyingError: String? = nil) {
      self.codingPath = codingPath
      self.debugDescription = debugDescription
      self.underlyingError = underlyingError
    }
  }
}


public extension EncodingError.Context {

  /// Конвертирует ``Swift.EncodingError.Context`` в ``CodableVersionOf.EncodingErrorContext``.
  var asCodableValue: CodableVersionOf.EncodingErrorContext {
    .init(self)
  }
}
