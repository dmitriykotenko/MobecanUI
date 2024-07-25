// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


extension CodableVersionOf {

  /// Аналог ``Swift.CodingKey``,
  /// реализующий протоколы ``Equatable``, ``Hashable`` и ``Codable``.
  ///
  /// Он нужен для работы с ``SerializationError`` и ``DeserializationError``.
  ///
  /// Примеры ключей сериализации:
  ///
  /// В JSON-объекте {"a": 1, "b": 2} ключами являются "a" и "b".
  ///
  /// В JSON-массиве [true, false, null] ключами являются 0, 1 и 2.
  @DerivesAutoGeneratable
  public struct CodingKey: Equatable, Hashable, Codable {

    /// Тип исходного объекта, реализующего протокол ``Swift.CodingKey`` (обычно нужен только для отладки).
    public var originalCodingKeyType: String

    /// Числовое значение ключа (обычно это — индекс объекта в JSON-массиве или в ``Array``).
    public var intValue: Int?

    /// Строковое значение ключа (обычно это — название поля в JSON-объекте или в ``Dictionary``).
    public var stringValue: String

    public var asJsonPathComponent: String {
      intValue.map { "[\($0)]" } ?? ".\(stringValue)"
    }

    public var asJsonPathStart: String {
      intValue.map { "[\($0)]" } ?? "\(stringValue)"
    }

    /// Конвертирует ``Swift.CodingKey`` в ``CodableVersionOf.CodingKey``.
    public init(_ origin: any Swift.CodingKey) {
      originalCodingKeyType = _typeName(type(of: origin), qualified: false)
      intValue = origin.intValue
      stringValue = origin.stringValue
    }

    public init(originalCodingKeyType: String,
                intValue: Int? = nil,
                stringValue: String) {
      self.originalCodingKeyType = originalCodingKeyType
      self.intValue = intValue
      self.stringValue = stringValue
    }
  }
}


public extension CodingKey {

  /// Конвертирует ``Swift.CodingKey`` в ``CodableVersionOf.CodingKey``.
  var asCodableValue: CodableVersionOf.CodingKey { .init(self) }
}


public extension [CodableVersionOf.CodingKey] {

  var asJsonPathString: String {
    ((first?.asJsonPathStart).asSequence + tail.map(\.asJsonPathComponent))
      .mkString()
  }
}
