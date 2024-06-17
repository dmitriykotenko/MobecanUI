// Copyright © 2024 Mobecan. All rights reserved.


/// Разновидность ``CodingKeysReflector``, не содержащая нет ни одного ``CodingKey``.
///
/// Подходит для строк, чисел, булевских значений, строковых или числовых енумов и других примитивных типов.
public protocol EmptyCodingKeysReflector: CodingKeysReflector {}


public extension EmptyCodingKeysReflector {

  static func typeOfValue(atCodingKey key: CodingKey) -> Result<CodingKeysReflector.Type, CodingKeysReflectorError> {
    .failure(.invalidCodingKey(key))
  }
}
