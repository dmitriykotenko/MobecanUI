// Copyright © 2024 Mobecan. All rights reserved.


/// Аналог ``Swift.EncodingError``, дополненный типом сериализуемого объекта
/// и реализующий протоколы ``Equatable``, ``Hashable`` и ``Codable``.
public enum SerializationError: Error, Equatable, Hashable, Codable {

  /// Произошёл ``EncodingError`` (который был сконвертирован в ``CodableVersionOf.EncodingError``).
  /// - Parameters:
  ///   - serializedType: Тип данных, которые не удалось сериализовать.
  ///   - encodingError: Произошедший ``EncodingError`` .
  case encodingError(
    serializedType: TypeName,
    encodingError: CodableVersionOf.EncodingError
  )

  /// Произошла ошибка, не являющаяся ``EncodingError``.
  ///
  /// - Warning: Может возникнуть при работе с try-catch-блоками
  /// (где у нас нет гарантии от компилятора, что произошёл именно ``EncodingError``).
  ///
  /// - Parameters:
  ///   - serializedType: Тип данных, которые не удалось сериализовать.
  ///   - errorType: Тип произошедшей ошибки.
  ///   - errorDescription: Описание произошедшей ошибки.
  case otherUnderlyingError(
    serializedType: TypeName,
    errorType: TypeName,
    errorDescription: String
  )

  /// Тип данных, которые не удалось сериализовать.
  var serializedType: TypeName {
    switch self {
    case .encodingError(let serializedType, _):
      return serializedType
    case .otherUnderlyingError(let serializedType, _, _):
      return serializedType
    }
  }

  /// Оборачивает любую ошибку в ``SerializationError``.
  ///
  /// - Warning: Этот конструктор нужен для работы с try-catch-блоками
  /// (где у нас нет гарантии от компилятора, что произошёл именно ``EncodingError``).
  ///
  /// - Parameters:
  ///   - anyError: Исходная ошибка (обычно это ``EncodingError``).
  ///   - serializedType: Тип данных, которые не удалось сериализовать.
  public init(anyError: Error,
              serializedType: Any.Type) {
    if let encodingError = anyError as? EncodingError {
      self = .init(
        encodingError,
        serializedType: serializedType
      )
    } else {
      self = .otherUnderlyingError(
        serializedType: .init(type: serializedType),
        errorType: .init(type: type(of: anyError)),
        errorDescription: "\(anyError)"
      )
    }
  }

  /// Конвертирует ``Swift.EncodingError`` в ``SerializationError``.
  /// - Parameters:
  ///   - origin: Исходный ``EncodingError``.
  ///   - serializedType: Тип данных, которые не удалось сериализовать.
  public init(_ origin: Swift.EncodingError,
              serializedType: Any.Type) {
    self = .encodingError(
      serializedType: .init(type: serializedType),
      encodingError: origin.asCodableValue
    )
  }
}


public extension EncodingError {

  /// Конвертирует ``Swift.EncodingError`` в ``SerializationError``.
  /// - Parameters:
  ///   - serializedType: Тип данных, которые не удалось сериализовать.
  func asCodableValue(serializedType: Any.Type) -> SerializationError {
    .init(
      self, 
      serializedType: serializedType
    )
  }
}
