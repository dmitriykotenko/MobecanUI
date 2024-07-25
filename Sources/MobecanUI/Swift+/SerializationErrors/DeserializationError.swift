// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


/// Ошибка при десериализации объекта, реализующего протокол ``Codable``.
///
/// Аналог ``Swift.DecodingError``, дополненный типом десериализуемого объекта
/// и реализующий протоколы ``Equatable``, ``Hashable`` и ``Codable``.
@DerivesAutoGeneratable
public enum DeserializationError: Error, Equatable, Hashable, Codable {

  /// Произошёл ``DecodingError`` (который был сконвертирован в ``CodableVersionOf.DecodingError``).
  /// - Parameters:
  ///   - deserializedType: Тип данных, который должен был получиться в результате десериализации.
  ///   - decodingError: Произошедший ``DecodingError``.
  case decodingError(
    deserializedType: TypeName,
    decodingError: CodableVersionOf.DecodingError
  )

  /// Произошла ошибка, не являющаяся ``DecodingError``.
  ///
  /// - Warning: Может возникнуть при работе с try-catch-блоками
  /// (где у нас нет гарантии от компилятора, что произошёл именно ``DecodingError``).
  ///
  /// - Parameters:
  ///   - deserializedType: Тип данных, который должен был получиться в результате десериализации.
  ///   - errorType: Тип произошедшей ошибки.
  ///   - errorDescription: Описание произошедшей ошибки.
  case otherUnderlyingError(
    deserializedType: TypeName,
    errorType: TypeName,
    errorDescription: String
  )

  /// Тип данных, который должен был получить в результате десериализации.
  var deserializedType: TypeName {
    switch self {
    case .decodingError(let deserializedType, _):
      return deserializedType
    case .otherUnderlyingError(let deserializedType, _, _):
      return deserializedType
    }
  }

  /// Оборачивает любую ошибку в ``DeserializationError``.
  ///
  /// - Warning: Этот конструктор нужен для работы с try-catch-блоками
  /// (где у нас нет гарантии от компилятора, что произошёл именно ``DecodingError``).
  ///
  /// - Parameters:
  ///   - anyError: Исходная ошибка (обычно это ``DecodingError``).
  ///   - deserializedType: Тип данных, который должен был получить в результате десериализации.
  public init(anyError: Error,
              deserializedType: Any.Type) {
    if let decodingError = anyError as? DecodingError {
      self = .init(
        decodingError, 
        deserializedType: deserializedType
      )
    } else {
      self = .otherUnderlyingError(
        deserializedType: .init(type: deserializedType),
        errorType: .init(type: type(of: anyError)),
        errorDescription: "\(anyError)"
      )
    }
  }

  /// Конвертирует ``Swift.DecodingError`` в ``DeserializationError``.
  /// - Parameters:
  ///   - origin: Исходный ``Swift.DecodingError``.
  ///   - deserializedType: Тип данных, который должен был получить в результате десериализации.
  public init(_ origin: Swift.DecodingError,
              deserializedType: Any.Type) {
    self = .decodingError(
      deserializedType: .init(type: deserializedType),
      decodingError: origin.asCodableValue
    )
  }
}


public extension DecodingError {

  /// Конвертирует ``Swift.DecodingError`` в ``DeserializationError``.
  /// - Parameters:
  ///   - deserializedType: Тип данных, который должен был получить в результате десериализации.
  func asCodableValue(deserializedType: Any.Type) -> DeserializationError {
    .init(
      self,
      deserializedType: deserializedType
    )
  }
}
