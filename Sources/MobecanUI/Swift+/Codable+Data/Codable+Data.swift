// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension Decodable {

  /// Deserialization of Codable values.
  ///
  /// - Warning: The method does not work properly for primitive types
  /// (strings, numbers, bools or enums without associated values)
  /// becase of a bug in JSONDecoder (https://bugs.swift.org/browse/SR-6163)
  static func fromData(_ data: Data, decoder: JSONDecoder = JSONDecoder()) -> Result<Self, SerializationError> {
    Result {
      try decoder.decode(Self.self, from: data)
    }
    .mapError {
      .canNotDeserialize(nestedError: $0)
    }
  }
}


/**
 @warn asdfsdf
 */
public extension Encodable {

  /// Serialization of Codable values.
  ///
  /// - Warning: The method does not work properly for primitive types
  /// (strings, numbers, bools or enums without associated values)
  /// becase of a bug in JSONEncoder (https://bugs.swift.org/browse/SR-6163)
  func toData(encoder: JSONEncoder = JSONEncoder()) -> Result<Data, SerializationError> {
    Result {
      try encoder.encode(self)
    }
    .mapError {
      .canNotSerialize(nestedError: $0)
    }
  }
}
