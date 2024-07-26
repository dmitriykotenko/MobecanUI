// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


/// Вспомогательная структура, чтобы настроить вероятность того,
/// что ``Result.BuiltinGenerator`` сгенерирует `.failure`.
///
/// Нужна, чтобы внутри ``GeneratorsFactory``
/// одной строкой переопределять вероятность генераци `.failure` сразу для всех ``Result.BuiltinGenerator``:
/// ```
/// let factory = StandardGeneratorsFactory()
///  .with(generating: IsError.self, by: .withProbability(0.7) )
/// ```
public struct IsError: AutoGeneratable {

  public var value: Bool

  public init(_ value: Bool) {
    self.value = value
  }

  public static var defaultGenerator: MobecanGenerator<IsError> {
    .pure {
      .init(Int.random(in: 1...10) == 1)
    }
  }
}


extension IsError: ExpressibleByBooleanLiteral {

  public init(booleanLiteral value: BooleanLiteralType) {
    self.init(value)
  }
}


public extension MobecanGenerator<IsError> {

  static func withProbability(_ probability: Double) -> MobecanGenerator<IsError> {
    .pure {
      .init(Double.random(in: 0..<1) < probability)
    }
  }
}
