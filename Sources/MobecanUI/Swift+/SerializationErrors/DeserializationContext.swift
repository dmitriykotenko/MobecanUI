// Copyright © 2024 Mobecan. All rights reserved.


/// Контекст произошедшей ошибки десериализации.
///
/// Аналог ``Swift.DecodingError.Context``, реализующий протоколы ``Equatable``, ``Hashable`` и ``Codable``.
public struct DeserializationContext: Equatable, Hashable, Codable {

  /// Полный путь к полю, которое не удалось десериализовать.
  ///
  /// Например, в JSON-объекте `{a1: [{b1: 1, b2: "2"}, {b2: "3"}, {b2: "4"}], a2: false}`
  /// путём может быть последовательность `["a1", 0, "b1"]`.
  /// Это значит, что ошибка произошла при десериализации поля a1[0].b1.
  public var codingPath: [SerializationKey]

  /// Подробности произошедшей ошибки, полезные при отладке.
  public var debugDescription: String

  /// Какая-то другая ошибка, которая является настоящей причиной ошибки десериализации.
  public var underlyingError: String?

  /// Конвертирует ``Swift.DecodingError.Context`` в ``DeserializationContext``.
  public init(_ origin: Swift.DecodingError.Context) {
    codingPath = origin.codingPath.map(\.asCodableValue)
    debugDescription = origin.debugDescription
    underlyingError = origin.underlyingError.map { "\($0)" }
  }
}


public extension DecodingError.Context {

  /// Конвертирует ``Swift.DecodingError.Context`` в ``DeserializationContext``.
  var asCodableValue: DeserializationContext {
    .init(self)
  }
}
