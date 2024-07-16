// Copyright © 2024 Mobecan. All rights reserved.

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MobecanUI

import RxSwift
import RxTest
import RxBlocking


final class GeneratorsTests: XCTestCase {

  @DerivesAutoGeneratable
  enum DecimalEnum: Codable {
    case positive(Decimal)
    case array([Decimal])
    case normalForm(mantissa: Decimal, exponent: Int)
  }

  func testFixedValueGenerator1() {
    check(
      generator: MobecanGenerator.fixed("London"),
      attempts: 200,
      ensureThatValue: { $0 == "London" }
    )
  }

  func testFixedValueGenerator2() {
    check(
      generator: MobecanGenerator.fixed("🔮"),
      attempts: 200,
      ensureThatValue: { $0 == "🔮" }
    )
  }

  func testBuiltinBoolGenerator() {
    check(
      generator: MobecanGenerator<[Bool]>.builtin(
        count: .fixed(1000),
        element: Bool.defaultGenerator
      ),
      attempts: 10,
      ensureThatValue: {
        $0.asSet == [true, false]
        && abs($0.filter { $0 == true }.count - 500) <= 100
      }
    )
  }

  func testGenerationOfFixedLengthArray() {
    check(
      generator: MobecanGenerator.builtin(
        count: .fixed(7),
        element: String.defaultGenerator
      ),
      attempts: 200,
      ensureThatValue: { $0.count == 7 }
    )
  }

  func testGenerationOfAlmostFixedLengthArray() {
    check(
      generator: MobecanGenerator<[[Double]]>.builtin(
        count: .fixed(1000),
        element: .builtin(
          count: .either([7, 15, 99]),
          element: Double.defaultGenerator
        )
      ),
      attempts: 1,
      ensureThatValue: {
        $0.map(\.count).asSet == [7, 15, 99]
      }
    )
  }

  func testArrayLengthDistribution() {
    check(
      generator: MobecanGenerator<[[String]]>.builtin(
        count: .fixed(1000)
      ),
      attempts: 10,
      ensureThatValue: {
        let valuesByLength = Dictionary(grouping: $0, by: \.count)

        let largeLengthsCount = valuesByLength
          .filter { length, _ in length > 5 }
          .map { $1.count }
          .reduce(0, +)

        return abs(valuesByLength[0]!.count - 500) <= 100
            && abs(valuesByLength[1]!.count - 250) <= 50
            && abs(valuesByLength[2]!.count - 125) <= 50
            && abs(valuesByLength[3]!.count - 62) <= 30
            && abs(valuesByLength[4]!.count - 31) <= 30
            && abs(valuesByLength[5]!.count - 15) <= 30
            && largeLengthsCount <= 50
      }
    )
  }

  func testOptionalityDistribution() {
    check(
      generator: MobecanGenerator<[String?]>.builtin(
        count: .fixed(1000)
      ),
      attempts: 10,
      ensureThatValue: {
        let nils = $0.filter { $0 == nil }
        let nonNils = $0.filter { $0 != nil }

        return abs(nils.count - 500) <= 100 && abs(nonNils.count - 500) <= 100
      }
    )
  }

  func testCorrectnessOfEitherGenerator() {
    check(
      generator: MobecanGenerator<[Int]>.builtin(
        count: .fixed(1000),
        element: .either([0, 666, 73, 14])
      ),
      attempts: 10,
      ensureThatValue: { $0.asSet == [0, 666, 73, 14] },
      errorMessage: {
        "'.either()' generator produced unexpected set of results: \($0.asSet.sorted())"
      }
    )
  }

  func testCorrectnessOfUnsafeEitherGenerator() {
    check(
      generator: MobecanGenerator<[Int]>.builtin(
        count: .fixed(1000),
        element: .unsafeEither([0, 666, 73, 14])
      ),
      attempts: 10,
      ensureThatValue: { $0.asSet == [0, 666, 73, 14] },
      errorMessage: {
        "'.unsafeEither()' generator produced unexpected set of results: \($0.asSet.sorted())"
      }
    )
  }

  func testErrorneousOfEmptyUnsafeEitherGenerator() {
    check(
      generator: MobecanGenerator<Int>.unsafeEither([]),
      attempts: 200,
      ensureThatResult: \.isError
    )
  }

  func testBuiltinFloatGenerator() {
    check(
      generator: MobecanGenerator<Float>.builtin(),
      attempts: 200,
      ensureThatValue: \.isFinite
    )
  }

  func testBuiltinDoubleGenerator() {
    check(
      generator: MobecanGenerator<Double>.builtin(),
      attempts: 200,
      ensureThatValue: \.isFinite
    )
  }

  func testSuccessfulnessOfUrlGenerator() {
    check(
      generator: URL.defaultGenerator,
      attempts: 200,
      ensureThatResult: \.isSuccess
    )
  }

  func testThatDirectBuiltinGeneratorIsNeverOverridenByFactory() {
    check(
      generator: Decimal.defaultGenerator,
      attempts: 200,
      ensureThatValue: { $0 != Decimal(555) }
    )
  }

  func testFactoryOverride1() {
    check(
      generator: MobecanGenerator<Decimal?>.builtin(),
      attempts: 200,
      ensureThatValue: { $0 == nil || $0 == Decimal(555) }
    )
  }

  func testFactoryOverride2() {
    check(
      generator: MobecanGenerator<DecimalEnum>.builtin(),
      attempts: 200,
      ensureThatValue: {
        switch $0 {
        case .positive(let decimal):
          return decimal == Decimal(555)
        case .array(let elements):
          return elements.isEmpty || elements.asSet == [Decimal(555)]
        case .normalForm(let mantissa, _):
          return mantissa == Decimal(555)
        }
      }
    )
  }

  private func check<Value: Codable>(
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

  private func check<Value>(
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
