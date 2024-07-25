// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


extension CodableVersionOf {

  /// Аналог ``Swift.EncodingError``, реализующий протоколы ``Equatable``, ``Hashable`` и ``Codable``.
  @DerivesAutoGeneratable
  public enum EncodingError: Error, Equatable, Hashable, Codable {

    /// Энкодеру или какому-то из его контейнеров не удалось сериализовать данные.
    /// - Parameters:
    ///   - valueDescription: Подробное описание данных, которые не удалось сериализовать.
    ///   - valueType: Тип данных, которые не удалось сериализовать.
    ///   - context: Подробности ошибки.
    case invalidValue(
      valueDescription: String, 
      valueType: TypeName,
      context: CodableVersionOf.EncodingErrorContext
    )

    /// Неизвестная разновидность ``EncodingError``.
    /// - Parameters:
    ///   - errorDescription: Описание ошибки.
    case unsupportedEncodingError(errorDescription: String)

    /// Конвертирует ``Swift.EncodingError`` в ``CodableVersionOf.EncodingError``.
    public init(_ origin: Swift.EncodingError) {
      switch origin {
      case .invalidValue(let value, let context):
        self = .invalidValue(
          valueDescription: "\(value)",
          valueType: .init(type: type(of: value)),
          context: context.asCodableValue
        )
      @unknown default:
        self = .unsupportedEncodingError(errorDescription: "\(origin)")
      }
    }
  }
}


public extension EncodingError {

  /// Конвертирует ``Swift.EncodingError`` в ``CodableVersionOf.EncodingError``.
  var asCodableValue: CodableVersionOf.EncodingError { .init(self) }
}
