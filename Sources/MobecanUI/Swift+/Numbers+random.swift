// Copyright © 2024 Mobecan. All rights reserved.

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
