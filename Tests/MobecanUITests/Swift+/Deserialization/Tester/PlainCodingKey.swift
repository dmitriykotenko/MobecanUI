// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


/// Реализация протокола ``CodingKey`` для тестов протокола ``CodingKeysReflector``.
struct PlainCodingKey: CodingKey {

  var intValue: Int?
  var stringValue: String

  init?(stringValue: String) {
    self.stringValue = stringValue
  }

  init?(intValue: Int) {
    self.intValue = intValue
    self.stringValue = "Index \(intValue)"
  }

  static func int(_ int: Int) -> Self {
    .init(intValue: int)!
  }

  static func string(_ string: String) -> Self {
    .init(stringValue: string)!
  }
}


extension CodableVersionOf.CodingKey {

  var asPlainKey: PlainCodingKey {
    intValue.map { .int($0) } ?? .string(stringValue)
  }
}
