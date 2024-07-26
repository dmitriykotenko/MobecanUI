// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


/// Вспомогательная структура, чтобы настроить вероятность того,
/// что ``Optional.BuiltinGenerator`` сгенерирует `nil`.
///
/// Нужна, чтобы внутри ``GeneratorsFactory``
/// одной строкой переопределять вероятность генераци `nil` сразу для всех ``Optional.BuiltinGenerator``:
/// ```
/// let factory = StandardGeneratorsFactory()
///  .with(generating: IsNil.self, by: .withProbability(0.7) )
/// ```
public struct IsNil: AutoGeneratable {

  public var value: Bool

  public init(_ value: Bool) {
    self.value = value
  }

  public static var defaultGenerator: MobecanGenerator<IsNil> {
    .pure { .init(Bool.random()) }
  }
}


extension IsNil: ExpressibleByBooleanLiteral {

  public init(booleanLiteral value: BooleanLiteralType) {
    self.init(value)
  }
}


public extension MobecanGenerator<IsNil> {

  static func withProbability(_ probability: Double) -> MobecanGenerator<IsNil> {
    .pure {
      .init(Double.random(in: 0..<1) < probability)
    }
  }
}
