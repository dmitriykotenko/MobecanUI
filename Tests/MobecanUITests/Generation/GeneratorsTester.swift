// Copyright © 2024 Mobecan. All rights reserved.

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MobecanUI

import RxSwift
import RxTest
import RxBlocking


class GeneratorsTester: XCTestCase {

  @DerivesAutoGeneratable
  enum DecimalEnum: Codable {
    case positive(Decimal)
    case array([Decimal])
    case normalForm(mantissa: Decimal, exponent: Int)
  }

  func check<Value: Codable>(
    generator: MobecanGenerator<Value>,
    attempts attemptsCount: Int,
    ensureThatValue: (Value) -> Bool,
    errorMessage: (Value) -> String = {
      "Generator produced unexpected result \($0.toJsonString(outputFormatting: .prettyPrinted))"
    },
    file: StaticString = #file,
    line: UInt = #line
  ) {
    check(
      generator: generator,
      attempts: attemptsCount,
      ensureThatResult: {
        switch $0 {
        case .success(let value):
          return ensureThatValue(value)
        case .failure:
          return false
        }
      },
      errorMessage: {
        switch $0 {
        case .success(let value):
          return errorMessage(value)
        case .failure(let error):
          return """
          Error when generating \(Value.self):
          \(error.toJsonString(outputFormatting: .prettyPrinted))
          """
        }
      },
      file: file,
      line: line
    )
  }

  func check<Value>(
    generator: MobecanGenerator<Value>,
    attempts attemptsCount: Int,
    ensureThatResult: (GeneratorResult<Value>) -> Bool,
    errorMessage: (GeneratorResult<Value>) -> String = { "Generator produced unexpected result \($0)" },
    file: StaticString = #file,
    line: UInt = #line
  ) {
    let factory = StandardGeneratorsFactory()
      .with(generating: Decimal.self, by: .fixed(Decimal(555)))

    let scheduler = TestScheduler(initialClock: 0)
    let listener = scheduler.createObserver([GeneratorResult<Value>].self)
    let disposeBag = DisposeBag()

    disposeBag {
      Single
        .zip((1...attemptsCount).map { _ in generator.generate(factory: factory) })
        ==> listener
    }

    scheduler.start()

    guard let results = listener.events[0].value.element
    else { XCTFail("No recorded '.next()' events.", file: file, line: line); return }

    results.forEach {
      if !ensureThatResult($0) {
        XCTFail(errorMessage($0), file: file, line: line)
      }
    }
  }
}
