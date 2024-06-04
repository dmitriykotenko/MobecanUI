// Copyright © 2024 Mobecan. All rights reserved.


/// Контекст произошедшей ошибки сериализации.
///
/// Аналог ``Swift.EncodingError.Context``, реализующий протоколы ``Equatable``, ``Hashable`` и ``Codable``.
public struct SerializationContext: Equatable, Hashable, Codable {

  /// Полный путь к полю, которое не удалось сериализовать.
  ///
  /// Например, в объекте `class User { let name: String; let parents: [User] }`
  /// путём может быть последовательность `["parents", 0, "name"]`.
  /// Это значит, что ошибка произошла при сериализации поля parents[0].name.
  var codingPath: [SerializationKey]

  /// Подробности произошедшей ошибки, полезные при отладке.
  var debugDescription: String

  /// Какая-то другая ошибка, которая является настоящей причиной ошибки сериализации.
  var underlyingError: String?

  /// Конвертирует ``Swift.EncodingError.Context`` в ``SerializationContext``.
  public init(_ origin: Swift.EncodingError.Context) {
    codingPath = origin.codingPath.map(\.asCodableValue)
    debugDescription = origin.debugDescription
    underlyingError = origin.underlyingError.map { "\($0)" }
  }
}


public extension EncodingError.Context {

  /// Конвертирует ``Swift.EncodingError.Context`` в ``SerializationContext``.
  var asCodableValue: SerializationContext {
    .init(self)
  }
}
