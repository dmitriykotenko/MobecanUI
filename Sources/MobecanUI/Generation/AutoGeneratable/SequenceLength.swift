// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift

// Все массивы по умолчанию будут иметь длину от 1 до 10:
let factory = StandardGeneratorsFactory()
  .with(
    generating: SequenceLength.self,
    by: .fixed(6)
  )
  .with(
    generating: SequenceLength.self,
    by: .pure { SequenceLength(UInt.random(in: 1...10)) }
  )
  .with(
    generating: SequenceLength.self,
    by: .pure {
      Bool.random() ? 0 : Bool.random() ? 1 : 2
    }
  )


/// Вспомогательная структура для настройки генерации размера массива или множества
/// в ``Array.BuiltinGenerator``, в ``Set.BuiltinGenerator`` и в ``GeneratorsFactory``.
///
/// Например:
///
/// ```
/// // Все массивы и множества по умолчанию будут иметь фиксированную длину в 6 элементов:
/// let factory = StandardGeneratorsFactory()
///   .with(
///     generating: SequenceLength.self,
///     by: .fixed(6)
///   )
/// ```
///
/// ```
/// // Все массивы и множества по умолчанию будут иметь равномерно распределённую длину от 1 до 10 элементов:
/// let factory = StandardGeneratorsFactory()
///   .with(
///     generating: SequenceLength.self,
///     by: .pure { SequenceLength(UInt.random(in: 1...10)) }
///   )
/// ```
///
/// ```
/// // Все массивы и множества с вероятностью 50 % будут пустыми,
/// с вероятностью 25% будут состоять из одного элемента и с вероятностью 25% будут состоять из 2 элементов:
/// let factory = StandardGeneratorsFactory()
///   .with(
///     generating: SequenceLength.self,
///     by: .pure { 
///       Bool.random() ? 0 : Bool.random() ? 1 : 2
///     }
///   )
/// ```
public struct SequenceLength: AutoGeneratable {

  public var value: UInt

  public init(_ value: UInt) {
    self.value = value
  }

  public static var defaultGenerator: MobecanGenerator<SequenceLength> {
    .rxFunctional {
      Bool.random() ?
        .just(.success(.init(0))) :
        SequenceLength.defaultGenerator.generate(factory: $0).mapSuccess {
          SequenceLength(1 + $0.value)
        }
    }
  }
}


extension SequenceLength: ExpressibleByIntegerLiteral {

  public init(integerLiteral value: IntegerLiteralType) {
    self.init(UInt(value))
  }
}
