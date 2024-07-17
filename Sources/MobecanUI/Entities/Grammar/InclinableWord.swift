// Copyright © 2024 Mobecan. All rights reserved.

import NonEmpty


/// Слово, склоняемое по падежам
/// (например: «смартфон», «смартфона», «смартфону», «смартфон», «смартфоном» и «смартфоне»).
@TryInit
public struct InclinableWord: Equatable, Hashable, Codable, Lensable {

  /// Именительный падеж (например: «смартфон»).
  public var nominativeCase: String

  /// Родительный падеж (например: «смартфона»).
  public var genitiveCase: String

  /// Дательный падеж (например: «смартфону»).
  public var dativeCase: String

  /// Винительный падеж (например: «ошибку»).
  public var accusativeCase: String

  /// Творительный падеж (например: «ошибкой»).
  public var instrumentalCase: String

  /// Предложный падеж (например: о «смартфоне»).
  public var prepositionalCase: String

  public init(nominativeCase: String,
              genitiveCase: String,
              dativeCase: String,
              accusativeCase: String,
              instrumentalCase: String,
              prepositionalCase: String) {
    self.nominativeCase = nominativeCase
    self.genitiveCase = genitiveCase
    self.dativeCase = dativeCase
    self.accusativeCase = accusativeCase
    self.instrumentalCase = instrumentalCase
    self.prepositionalCase = prepositionalCase
  }
}
