// Copyright © 2024 Mobecan. All rights reserved.

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MobecanUI

import RxSwift
import RxTest
import RxBlocking


final class AutoGeneratableMacroTests: MacrosTester {

  func testEmptyStruct() {
    checkThat(
      code: """
      @DerivesAutoGeneratable private struct Empty {}
      """,
      expandsTo: """
      private struct Empty {

        class BuiltinGenerator: MobecanGenerator<Empty> {

          override func generate(factory: GeneratorsFactory) -> Single<GeneratorResult<Empty>> {
            .just(.success(Empty()))
          }
        }
      }

      extension Empty: AutoGeneratable {

        static var defaultGenerator: BuiltinGenerator {
          .init()
        }
      }
      """
    )
  }

  func testSimpleStruct() {
    checkThat(
      code: """
      @DerivesAutoGeneratable
      struct Pair {
        var first: String
        var second: Int?
      }
      """,
      expandsTo: """
      struct Pair {
        var first: String
        var second: Int?

        class BuiltinGenerator: MobecanGenerator<Pair> {

          var first: MobecanGenerator<String>
          var second: MobecanGenerator<Int?>
          init(first: MobecanGenerator<String> = AsAutoGeneratable<String>.defaultGenerator,
               second: MobecanGenerator<Int?> = AsAutoGeneratable<Int?>.defaultGenerator) {
            self.first = first
            self.second = second
            super.init()
          }
          static func using(
            first: MobecanGenerator<String> = AsAutoGeneratable<String>.defaultGenerator,
            second: MobecanGenerator<Int?> = AsAutoGeneratable<Int?>.defaultGenerator
          ) -> BuiltinGenerator {
            .init(first: first, second: second)
          }
          override func generate(factory: GeneratorsFactory) -> Single<GeneratorResult<Pair>> {
            Single
              .zip(
                factory.generate(via: first),
                factory.generate(via: second)
              )
              .map {
                zip($0, $1)
              }
              .mapSuccess {
                Pair(first: $0, second: $1)
              }
          }
        }
      }

      extension Pair: AutoGeneratable {

        static var defaultGenerator: BuiltinGenerator {
          .init()
        }
      }
      """
    )
  }

  func testStructWithSingleProperty() {
    checkThat(
      code: """
      @DerivesAutoGeneratable
      struct Container {
        var value: String
      }
      """,
      expandsTo: """
      struct Container {
        var value: String

        class BuiltinGenerator: MobecanGenerator<Container> {

          var value: MobecanGenerator<String>
          init(value: MobecanGenerator<String> = AsAutoGeneratable<String>.defaultGenerator) {
            self.value = value
            super.init()
          }
          static func using(
            value: MobecanGenerator<String> = AsAutoGeneratable<String>.defaultGenerator
          ) -> BuiltinGenerator {
            .init(value: value)
          }
          override func generate(factory: GeneratorsFactory) -> Single<GeneratorResult<Container>> {
            factory
              .generate(via: value)
              .mapSuccess {
                Container(value: $0)
              }
          }
        }
      }

      extension Container: AutoGeneratable {

        static var defaultGenerator: BuiltinGenerator {
          .init()
        }
      }
      """
    )
  }

  func testStructWithTupleProperties() {
    checkThat(
      code: """
      struct Good {
        var int: Int
        var string: String
      }

      protocol Owner {
        var ownedString: String { get }
      }

      @DerivesAutoGeneratable
      struct NotGood {
        var reallyNotGood: [(Int, String, and: Bool)?]
        var maybeGood: Good
        var notGoodToo: (Good, Decimal)
      }
      """,
      expandsTo: """
      struct Good {
        var int: Int
        var string: String
      }

      protocol Owner {
        var ownedString: String { get }
      }
      struct NotGood {
        var reallyNotGood: [(Int, String, and: Bool)?]
        var maybeGood: Good
        var notGoodToo: (Good, Decimal)
      }
      """,
      withDiagnostics: [
        .init(
          message: "Макрос @DerivesAutoGeneratable не поддерживает тьюплы.",
          line: 12,
          column: 23
        ),
        .init(
          message: "Макрос @DerivesAutoGeneratable не поддерживает тьюплы.",
          line: 14,
          column: 19
        )
      ]
    )
  }

  func testClass() {
    checkThat(
      code: "@DerivesAutoGeneratable class NotGood {}",
      expandsTo: "class NotGood {}",
      withDiagnostics: [
        .init(
          message: "Макрос @DerivesAutoGeneratable поддерживает только структуры и енумы.",
          line: 1,
          column: 1
        )
      ]
    )
  }

  func testProtocol() {
    checkThat(
      code: "@DerivesAutoGeneratable protocol NotGood {}",
      expandsTo: "protocol NotGood {}",
      withDiagnostics: [
        .init(
          message: "Макрос @DerivesAutoGeneratable поддерживает только структуры и енумы.",
          line: 1,
          column: 1
        )
      ]
    )
  }
}
