// Copyright © 2020 Mobecan. All rights reserved.

import NonEmpty


/// Имя существительное.
@TryInit
public struct Noun: Equatable, Hashable, Codable, Lensable {

  /// Форма для одного предмета.
  public var initialForm: InclinableWord

  /// Форма для нуля предметов.
  public var zero: InclinableWord

  /// Форма для небольшого количества предметов.
  public var few: InclinableWord

  /// Форма для большого количества предметов.
  public var many: InclinableWord

  public init(initialForm: InclinableWord,
              zero: InclinableWord,
              few: InclinableWord,
              many: InclinableWord) {
    self.initialForm = initialForm
    self.zero = zero
    self.few = few
    self.many = many
  }

  public func asCountableWord(grammaticalCase: KeyPath<InclinableWord, String>) -> CountableWord {
    .init(
      initialForm: initialForm[keyPath: grammaticalCase],
      zero: zero[keyPath: grammaticalCase],
      few: few[keyPath: grammaticalCase],
      many: many[keyPath: grammaticalCase]
    )
  }
}
