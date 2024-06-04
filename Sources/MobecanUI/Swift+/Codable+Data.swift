// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension Encodable {

  /// Сериализация Codable-объектов.
  ///
  /// - Warning: Функция неправильно работает для примитивных типов данных
  /// (строк, чисел, булевских значений и енумов без ассоциированных значений)
  /// из-за бага в JSONEncoder (https://bugs.swift.org/browse/SR-6163).
  func toData(encoder: JSONEncoder = JSONEncoder()) -> Result<Data, SerializationError> {
    Result {
      try encoder.encode(self)
    }
    .mapError(\.asSerializationError)
  }
}


public extension Decodable {

  /// Десериализация Codable-объектов.
  ///
  /// - Warning: Функция неправильно работает для примитивных типов данных
  /// (строк, чисел, булевских значений и енумов без ассоциированных значений)
  /// из-за бага в JSONDecoder (https://bugs.swift.org/browse/SR-6163).
  static func fromData(_ data: Data,
                       decoder: JSONDecoder = JSONDecoder()) -> Result<Self, DeserializationError> {
    Result {
      try decoder.decode(Self.self, from: data)
    }
    .mapError(\.asDeserializationError)
  }
}


private extension Error {

  var asSerializationError: SerializationError { .init(anyError: self) }
  var asDeserializationError: DeserializationError { .init(anyError: self) }
}
