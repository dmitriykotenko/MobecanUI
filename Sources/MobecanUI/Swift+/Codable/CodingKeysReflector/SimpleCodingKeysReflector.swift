// Copyright © 2024 Mobecan. All rights reserved.


/// Разновидность ``CodingKeysReflector``, содержащая фиксированный набор строковых ``CodingKey``.
///
/// Подходит для большинства классов и структур.
public protocol SimpleCodingKeysReflector: CodingKeysReflector {

  static var codingKeyTypes: [String: CodingKeysReflector.Type] { get }
}


public extension SimpleCodingKeysReflector {

  static func typeOfValue(atCodingKey key: CodingKey) -> Result<CodingKeysReflector.Type, CodingKeysReflectorError> {
    switch codingKeyTypes[key.stringValue] {
    case let type? where key.intValue == nil :
      return .success(type)
    default:
      return .failure(.invalidCodingKey(key))
    }
  }
}
