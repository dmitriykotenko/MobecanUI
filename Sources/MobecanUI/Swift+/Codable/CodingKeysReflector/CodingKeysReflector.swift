// Copyright © 2024 Mobecan. All rights reserved.

import Foundation


/// Рассказывает, какой тип получится, если у объекта попросить значение,
/// лежащее по любому указанному ``CodingKey``.
public protocol CodingKeysReflector: Codable {

  /// Тип значения по указанному ``CodingKey``.
  static func typeOfValue(atCodingKey: CodingKey) -> Result<CodingKeysReflector.Type, CodingKeysReflectorError>
}


public extension CodingKeysReflector {

  /// Тип значения по указанному пути, состоящем из ``CodingKey``.
  /// Если путь пустой, возвращает `Self.self`.
  static func typeOfValue(atCodingPath path: [CodingKey])
  -> Result<CodingKeysReflector.Type, CodingKeysReflectorError> {
    switch path.first {
    case nil:
      return .success(Self.self)
    case let firstKey?:
      return typeOfValue(atCodingKey: firstKey)
        .flatMap { $0.typeOfValue(atCodingPath: path.tail) }
        .mapError { $0.wrap(inside: path) }
    }
  }

  /// Типы значений по каждому ``CodingKey`` из указанного пути.
  static func types(forCodingPath path: [CodingKey])
  -> Result<[CodingKeysReflector.Type], CodingKeysReflectorError> {
    path.headsIncludingSelf
      .map { typeOfValue(atCodingPath: $0) }
      .invert()
      .map { [Self.self] + $0 }
  }
}
