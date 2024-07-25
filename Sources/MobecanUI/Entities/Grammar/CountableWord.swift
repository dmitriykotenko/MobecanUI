// Copyright © 2024 Mobecan. All rights reserved.

import NonEmpty
import RxSwift


/// Слово, у которого есть разные формы для обозначения разного количества
/// (например: «1 смартфон», «2 смартфона», «5 смартфонов»).
@DerivesAutoGeneratable
@TryInit
public struct CountableWord: Equatable, Hashable, Codable, Lensable {

  /// Форма для одного предмета (например: 1 «смартфон»).
  public var initialForm: String

  /// Форма для нуля предметов (например: 0 «смартфонов»).
  public var zero: String

  /// Форма для небольшого количества предметов (например: 3 «смартфона»).
  public var few: String

  /// Форма для большого количества предметов (например: 5 «смартфонов»).
  public var many: String

  public init(initialForm: String,
              zero: String,
              few: String,
              many: String) {
    self.initialForm = initialForm
    self.zero = zero
    self.few = few
    self.many = many
  }
}
