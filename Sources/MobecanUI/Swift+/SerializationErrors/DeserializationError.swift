// Copyright © 2024 Mobecan. All rights reserved.


/// Аналог ``Swift.DecodingError``, реализующий протоколы ``Equatable``, ``Hashable`` и ``Codable``.
public enum DeserializationError: Error, Equatable, Hashable, Codable {

  /// Кривые или повреждённые данные для десериализации
  /// (например, Data, которая не является валидным JSON).
  /// - Parameters:
  ///   - context: Подробности ошибки.
  case dataCorrupted(context: DeserializationContext)

  /// В декодинг-контейнере не оказалось данных для указанного ключа
  /// (например, в JSON-объекте отсутствует требуемое поле).
  /// - Parameters:
  ///   - codingKey: Название отсутствующего поля или индекс, отсутствующий в массиве.
  ///   - context: Подробности ошибки.
  case keyNotFound(codingKey: SerializationKey, context: DeserializationContext)

  /// Из данных невозможно воссоздать нужный тип
  /// (например, в одном из полей JSON-объекта лежит строка вместо числа).
  /// - Parameters:
  ///   - expectedType: Тип данных, который не удалось воссоздать.
  ///   - context: Подробности ошибки.
  case typeMismatch(expectedType: String, context: DeserializationContext)

  /// В результате десериализации получился `nil`, хотя ожидался неопциональный тип данных
  /// (например, в одном из полей JSON-объекта, которое должно было быть обязательным, лежит null).
  /// - Parameters:
  ///   - expectedType: Неопциональный тип данных, который не удалось десериализовать.
  ///   - context: Подробности ошибки.
  case valueNotFound(expectedType: String, context: DeserializationContext)

  /// Неизвестная разновидность ``DecodingError``.
  /// - Parameters:
  ///   - errorDescription: Описание ошибки.
  case unsupportedDecodingError(errorDescription: String)

  /// Ошибка, не являющаяся ``DecodingError``.
  ///
  /// - Warning: Может возникнуть при работе с try-catch-блоками,
  /// где у нас нет гарантии, что произошёл именно ``DecodingError``.
  /// 
  /// - Parameters:
  ///   - expectedType: Тип ошибки.
  ///   - context: Описание ошибки.
  case otherUnderlyingError(errorType: String, errorDescription: String)

  /// Оборачивает любую ошибку в ``DeserializationError``.
  ///
  /// - Warning: Этот конструктор нужен для работы с try-catch-блоками,
  /// где у нас нет гарантии, что произошёл именно ``DecodingError``.
  ///
  /// - Parameter origin: Исходная ошибка (обычно это ``DecodingError``).
  public init(anyError: Error) {
    if let decodingError = anyError as? DecodingError {
      self = .init(decodingError)
    } else {
      self = .otherUnderlyingError(
        errorType: "\(type(of: anyError))",
        errorDescription: "\(anyError)"
      )
    }
  }

  /// Конвертирует ``Swift.DecodingError`` в ``DeserializationError``.
  public init(_ origin: Swift.DecodingError) {
    switch origin {
    case .dataCorrupted(let context):
      self = .dataCorrupted(
        context: context.asCodableValue
      )
    case .keyNotFound(let codingKey, let context):
      self = .keyNotFound(
        codingKey: codingKey.asCodableValue,
        context: context.asCodableValue
      )
    case .typeMismatch(let expectedType, let context):
      self = .typeMismatch(
        expectedType: "\(type(of: expectedType))",
        context: context.asCodableValue
      )
    case .valueNotFound(let expectedType, let context):
      self = .valueNotFound(
        expectedType: "\(type(of: expectedType))",
        context: context.asCodableValue
      )
    @unknown default:
      self = .unsupportedDecodingError(errorDescription: "\(origin)")
    }
  }
}


public extension DecodingError {

  /// Конвертирует ``Swift.DecodingError`` в ``DeserializationError``.
  var asCodableValue: DeserializationError { .init(self) }
}
