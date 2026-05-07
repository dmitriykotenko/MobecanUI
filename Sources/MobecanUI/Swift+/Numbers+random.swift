// Copyright © 2024 Mobecan. All rights reserved.

import Foundation
import RxSwift


public extension Int8 {

  static var random: Int8 { .random(in: Int8.min...Int8.max) }
}


public extension UInt8 {

  static var random: UInt8 { .random(in: UInt8.min...UInt8.max) }
}


public extension Int16 {

  static var random: Int16 { .random(in: Int16.min...Int16.max) }
}


public extension UInt16 {

  static var random: UInt16 { .random(in: UInt16.min...UInt16.max) }
}


public extension Int32 {

  static var random: Int32 { .random(in: Int32.min...Int32.max) }
}


public extension UInt32 {

  static var random: UInt32 { .random(in: UInt32.min...UInt32.max) }
}


public extension Int64 {

  static var random: Int64 { .random(in: Int64.min...Int64.max) }
}


public extension UInt64 {

  static var random: UInt64 { .random(in: UInt64.min...UInt64.max) }
}


public extension Int {

  static var random: Int { .random(in: Int.min...Int.max) }
}


public extension UInt {

  static var random: UInt { .random(in: UInt.min...UInt.max) }
}


public extension Float {

  static var random: Float {
    // Из-за бага стандартной библиотеки Свифта
    // нельзя сразу использовать полный диапазон для `Float.random(in:)` и `Double.random(in:)`:
    // https://stackoverflow.com/a/75467362
    Bool.random() ?
      .random(in: -Float.greatestFiniteMagnitude...0) :
      .random(in: 0...Float.greatestFiniteMagnitude)
  }
}


public extension Double {

  static var random: Double {
    // Из-за бага стандартной библиотеки Свифта
    // нельзя сразу использовать полный диапазон для `Float.random(in:)` и `Double.random(in:)`:
    // https://stackoverflow.com/a/75467362
    Bool.random() ?
      .random(in: -Double.greatestFiniteMagnitude...0) :
      .random(in: 0...Double.greatestFiniteMagnitude)
  }
}


public extension Decimal {

  static var random: Decimal { randomAcrossFoundationRange() }

  static func randomAcrossFoundationRange<Generator: RandomNumberGenerator>(
    using generator: inout Generator
  ) -> Decimal {
    // Иногда возвращаем ноль отдельно,
    // потому что схема ниже генерирует только ненулевые числа.
    if Int.random(in: 0..<1000, using: &generator) == 0 { return 0 }

    let isNegative = Bool.random(using: &generator)

    // Decimal / NSDecimalNumber: мантисса до 38 десятичных цифр.
    let digitCount = Int.random(in: 1...38, using: &generator)

    // Первая цифра не ноль, чтобы не получать неканонические варианты
    // вроде 00000123e10.
    let firstDigit = Int.random(in: 1...9, using: &generator)

    let tailDigits: [Int] = (1..<digitCount).map { _ in
      .random(in: 0...9, using: &generator)
    }

    let digits = ([firstDigit] + tailDigits).mkString()

    // Decimal / NSDecimalNumber: exponent от -128 до 127.
    let exponent = Int.random(in: -128...127, using: &generator)

    let string = "\(isNegative ? "-" : "")\(digits)e\(exponent)"

    guard let result = Decimal(string: string, locale: Locale(identifier: "en_US_POSIX")) else {
      // Теоретически сюда не должны попасть, если Foundation соблюдает
      // документированный диапазон.
      return Self.randomAcrossFoundationRange(using: &generator)
    }

    return result
  }

  static func randomAcrossFoundationRange() -> Decimal {
    var generator = SystemRandomNumberGenerator()

    return randomAcrossFoundationRange(using: &generator)
  }
}
