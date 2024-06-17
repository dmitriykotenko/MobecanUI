// Copyright © 2024 Mobecan. All rights reserved.


/// Ошибка при попытке узнать тип значения у ``CodingKeysReflector``.
public indirect enum CodingKeysReflectorError: Error, Equatable, Hashable, Codable {

  /// Несуществующий ``CodingKey``.
  case invalidCodingKey(CodableVersionOf.CodingKey)

  /// Вложенная ошибка, произошедшая при попытке узнать тип значения для указанного ``path``.
  case invalidCodingPath(
    path: [CodableVersionOf.CodingKey], 
    nestedError: CodingKeysReflectorError
  )

  public static func invalidCodingKey(_ key: CodingKey) -> Self {
    .invalidCodingKey(key.asCodableValue)
  }

  public func wrap(inside codingPath: [CodingKey]) -> Self {
    .invalidCodingPath(
      path: codingPath.map(\.asCodableValue),
      nestedError: self
    )
  }
}
