// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


extension CodableVersionOf {

  /// Аналог ``Swift.DecodingError``, реализующий протоколы ``Equatable``, ``Hashable`` и ``Codable``.
  @DerivesAutoGeneratable
  public enum DecodingError: Error, Equatable, Hashable, Codable {

    /// Кривые или повреждённые данные для десериализации
    /// (например, Data, которая не является валидным JSON).
    /// - Parameters:
    ///   - context: Подробности ошибки.
    case dataCorrupted(context: CodableVersionOf.DecodingErrorContext)

    /// В декодинг-контейнере не оказалось данных для указанного ключа
    /// (например, в JSON-объекте отсутствует требуемое поле).
    /// - Parameters:
    ///   - codingKey: Название отсутствующего поля или индекс, отсутствующий в массиве.
    ///   - context: Подробности ошибки.
    case keyNotFound(
      codingKey: CodableVersionOf.CodingKey, 
      context: CodableVersionOf.DecodingErrorContext
    )

    /// Из данных невозможно воссоздать нужный тип
    /// (например, в одном из полей JSON-объекта лежит строка вместо числа).
    /// - Parameters:
    ///   - expectedType: Тип данных, который не удалось воссоздать.
    ///   - context: Подробности ошибки.
    case typeMismatch(
      expectedType: TypeName,
      context: CodableVersionOf.DecodingErrorContext
    )

    /// В результате десериализации получился `nil`, хотя ожидался неопциональный тип данных
    /// (например, в одном из полей JSON-объекта, которое должно было быть обязательным, лежит null).
    /// - Parameters:
    ///   - expectedType: Неопциональный тип данных, который не удалось десериализовать.
    ///   - context: Подробности ошибки.
    case valueNotFound(
      expectedType: TypeName,
      context: CodableVersionOf.DecodingErrorContext
    )

    /// Случилась неизвестная разновидность ``DecodingError``.
    /// - Parameters:
    ///   - errorDescription: Описание ошибки.
    case unsupportedDecodingError(errorDescription: String)

    /// Конвертирует ``Swift.DecodingError`` в ``CodableVersionOf.DecodingError``.
    public init(_ origin: Swift.DecodingError) {
      switch origin {
      case .dataCorrupted(let context):
        self = .dataCorrupted(context: context.asCodableValue)
      case .keyNotFound(let codingKey, let context):
        self = .keyNotFound(
          codingKey: codingKey.asCodableValue,
          context: context.asCodableValue
        )
      case .typeMismatch(let expectedType, let context):
        self = .typeMismatch(
          expectedType: .init(type: expectedType),
          context: context.asCodableValue
        )
      case .valueNotFound(let expectedType, let context):
        self = .valueNotFound(
          expectedType: .init(type: expectedType),
          context: context.asCodableValue
        )
      @unknown default:
        self = .unsupportedDecodingError(errorDescription: "\(origin)")
      }
    }
  }
}


public extension DecodingError {

  /// Конвертирует ``Swift.DecodingError`` в ``CodableVersionOf.DecodingError``.
  var asCodableValue: CodableVersionOf.DecodingError {
    .init(self)
  }
}
