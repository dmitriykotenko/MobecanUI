// Copyright © 2024 Mobecan. All rights reserved.

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MobecanUI

import RxSwift
import RxTest
import RxBlocking


final class GeneratorsTests: GeneratorsTester {

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

  func testGenerationOfDoubleOptional() {
    check(
      generator: MobecanGenerator<[String??]>.builtin(
        count: .fixed(100),
        element: String??.defaultGenerator
      ),
      attempts: 1,
      ensureThatResult: \.isSuccess
    )
  }

  func testJsonValueGeneration() {
    check(
      generator: MobecanGenerator<[JsonValue]>.builtin(
        count: .fixed(100),
        element: JsonValue.defaultGenerator.filter(
          .init {
            $0.height >= 3 ?
              GeneratorResult.success($0) :
              GeneratorResult.failure(GeneratorError(message: "Inappropriate JsonValue"))
          },
          maximumAttemptsCount: 1000
        )
      ),
      attempts: 1,
      ensureThatResult: \.isSuccess
    )
  }
}


private extension JsonValue {

  var height: Int {
    switch self {
    case .string, .int, .bool, .double, .null:
      return 0
    case .object(let dictionary):
      return dictionary.values.map(\.height).reduce(0, max) + 1
    case .array(let array):
      return array.map(\.height).reduce(0, max) + 1
    }
  }
}
