// Copyright © 2024 Mobecan. All rights reserved.


/// Аналог ``Swift.EncodingError``, реализующий протоколы ``Equatable``, ``Hashable`` и ``Codable``.
public enum SerializationError: Error, Equatable, Hashable, Codable {

  /// Энкодеру или какому-то из его контейнеров не удалось сериализовать данные.
  /// - Parameters:
  ///   - valueDescription: Подробное описание данных, которые не удалось сериализовать.
  ///   - valueType: Тип данных, которые не удалось сериализовать.
  ///   - context: Подробности ошибки.
  case invalidValue(valueDescription: String, valueType: String, context: SerializationContext)

  /// Неизвестная разновидность ``EncodingError``.
  /// - Parameters:
  ///   - errorDescription: Описание ошибки.
  case unsupportedEncodingError(errorDescription: String)

  /// Ошибка, не являющаяся ``EncodingError``.
  ///
  /// - Warning: Может возникнуть при работе с try-catch-блоками,
  /// где у нас нет гарантии, что произошёл именно ``DecodingError``.
  ///
  /// - Parameters:
  ///   - expectedType: Тип ошибки.
  ///   - context: Описание ошибки.
  case otherUnderlyingError(errorType: String, errorDescription: String)

  /// Оборачивает любую ошибку в ``SerializationError``.
  ///
  /// - Warning: Этот конструктор нужен для работы с try-catch-блоками,
  /// где у нас нет гарантии, что произошёл именно ``EncodingError``.
  ///
  /// - Parameter origin: Исходная ошибка (обычно это ``EncodingError``).
  public init(anyError: Error) {
    if let encodingError = anyError as? EncodingError {
      self = .init(encodingError)
    } else {
      self = .otherUnderlyingError(
        errorType: "\(type(of: anyError))",
        errorDescription: "\(anyError)"
      )
    }
  }

  /// Конвертирует ``Swift.EncodingError`` в ``SerializationError``.
  public init(_ origin: Swift.EncodingError) {
    switch origin {
    case .invalidValue(let value, let context):
      self = .invalidValue(
        valueDescription: "\(value)",
        valueType: "\(type(of: value))",
        context: context.asCodableValue
      )
    @unknown default:
      self = .unsupportedEncodingError(errorDescription: "\(origin)")
    }
  }
}


public extension EncodingError {

  /// Конвертирует ``Swift.EncodingError`` в ``SerializationError``.
  var asCodableValue: SerializationError { .init(self) }
}
