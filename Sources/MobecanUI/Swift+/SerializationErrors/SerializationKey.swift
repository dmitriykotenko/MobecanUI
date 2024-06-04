// Copyright © 2024 Mobecan. All rights reserved.


/// Так называемый «ключ сериализации» (обычно это — строка или число).
///
/// ``SerializationKey`` — это аналог ``Swift.CodingKey``,
/// реализующий протоколы ``Equatable``, ``Hashable`` и ``Codable``.
///
/// Он нужен для работы с ``SerializationError`` и ``DeserializationError``.
///
/// Примеры ключей сериализации:
///
/// В JSON-объекте {"a": 1, "b": 2} ключами являются "a" и "b".
/// 
/// В JSON-массиве [true, false, null] ключами являются 0, 1 и 2.
public struct SerializationKey: Equatable, Hashable, Codable {

  /// Тип исходного объекта, реализующего протокол ``Swift.CodingKey`` (обычно нужен только для отладки).
  public var originalCodingKeyType: String

  /// Числовое значение ключа (обычно это — индекс объекта в JSON-массиве или в ``Array``).
  public var intValue: Int?

  /// Строковое значение ключа (обычно это — название поля в JSON-объекте или в ``Dictionary``).
  public var stringValue: String

  /// Конвертирует ``Swift.CodingKey`` в ``SerializationKey``.
  public init(_ origin: any Swift.CodingKey) {
    originalCodingKeyType = "\(type(of: origin))"
    intValue = origin.intValue
    stringValue = origin.stringValue
  }
}


public extension CodingKey {

  /// Конвертирует ``Swift.CodingKey`` в ``SerializationKey``.
  var asCodableValue: SerializationKey { .init(self) }
}
