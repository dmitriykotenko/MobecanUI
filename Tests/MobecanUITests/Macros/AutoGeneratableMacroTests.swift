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
      @DerivesAutoGeneratable struct Empty {}
      """,
      expandsTo: """
      struct Empty {

        public class BuiltinGenerator: MobecanGenerator<Empty> {

          override public func generate(factory: GeneratorsFactory) -> Single<GeneratorResult<Empty>> {
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

        public class BuiltinGenerator: MobecanGenerator<Pair> {

          var first: MobecanGenerator<String>
          var second: MobecanGenerator<Int?>
          public init(first: MobecanGenerator<String> = AsAutoGeneratable<String>.defaultGenerator,
                      second: MobecanGenerator<Int?> = AsAutoGeneratable<Int?>.defaultGenerator) {
            self.first = first
            self.second = second
            super.init()
          }
          public static func using(
            first: MobecanGenerator<String> = AsAutoGeneratable<String>.defaultGenerator,
            second: MobecanGenerator<Int?> = AsAutoGeneratable<Int?>.defaultGenerator
          ) -> BuiltinGenerator {
            .init(first: first, second: second)
          }
          override public func generate(factory: GeneratorsFactory) -> Single<GeneratorResult<Pair>> {
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

  func testSimpleEnum() {
    checkThat(
      code: """
      @DerivesAutoGeneratable
      enum Medal {
        case gold
        case silver
        case bronze
      }
      """,
      expandsTo: """
      enum Medal {
        case gold
        case silver
        case bronze
      }

      extension Medal: AutoGeneratable {

        static var defaultGenerator: MobecanGenerator<Medal> {
          .oneOf(.gold, .silver, .bronze)
        }
      }
      """
    )
  }

  func testSimpleEnumInCompactForm() {
    checkThat(
      code: """
      @DerivesAutoGeneratable
      enum Medal {
        case gold, silver, bronze
      }
      """,
      expandsTo: """
      enum Medal {
        case gold, silver, bronze
      }

      extension Medal: AutoGeneratable {

        static var defaultGenerator: MobecanGenerator<Medal> {
          .oneOf(.gold, .silver, .bronze)
        }
      }
      """
    )
  }

  func testComplexGenericEnum() {
    checkThat(
      code: """
      @DerivesAutoGeneratable
      enum Subject<Animal, Human> {
        case legalPerson
        case animal(Animal)
        case human(Human, age: Int)
      }
      """,
      expandsTo: """
      enum Subject<Animal, Human> {
        case legalPerson
        case animal(Animal)
        case human(Human, age: Int)

        public class BuiltinGenerator: MobecanGenerator<Subject>
        where Animal: AutoGeneratable, Human: AutoGeneratable {

          enum Cases: CaseIterable {
            case legalPerson
            case animal
            case human
          }
          public class Generator_animal: FunctionalGenerator<Animal> {
            public class Builtin: MobecanGenerator<Animal> {
              var _0: MobecanGenerator<Animal>
              public init(_ _0: MobecanGenerator<Animal> = AsAutoGeneratable<Animal>.defaultGenerator) {
                self._0 = _0
                super.init()
              }
              public static func using(
                _ _0: MobecanGenerator<Animal> = AsAutoGeneratable<Animal>.defaultGenerator
              ) -> Builtin {
                .init(_0)
              }
              override public func generate(factory: GeneratorsFactory) -> Single<GeneratorResult<Animal>> {
                factory.generate(via: _0)
              }
            }
            static func builtin(
              _ _0: MobecanGenerator<Animal> = AsAutoGeneratable<Animal>.defaultGenerator
            ) -> Generator_animal {
              .init {
                Builtin(_0).generate(factory: $0)
              }
            }
          }
          public class Generator_human: FunctionalGenerator<(Human, age: Int)> {
            public class Builtin: MobecanGenerator<(Human, age: Int)> {
              var _0: MobecanGenerator<Human>
              var age: MobecanGenerator<Int>
              public init(_ _0: MobecanGenerator<Human> = AsAutoGeneratable<Human>.defaultGenerator,
                          age: MobecanGenerator<Int> = AsAutoGeneratable<Int>.defaultGenerator) {
                self._0 = _0
                self.age = age
                super.init()
              }
              public static func using(
                _ _0: MobecanGenerator<Human> = AsAutoGeneratable<Human>.defaultGenerator,
                age: MobecanGenerator<Int> = AsAutoGeneratable<Int>.defaultGenerator
              ) -> Builtin {
                .init(_0, age: age)
              }
              override public func generate(factory: GeneratorsFactory)
              -> Single<GeneratorResult<(Human, age: Int)>> {
                Single
                  .zip(
                    factory.generate(via: _0),
                    factory.generate(via: age)
                  )
                  .map {
                    zip($0, $1)
                  }
                  .mapSuccess {
                    ($0, age: $1)
                  }
              }
            }
            static func builtin(
              _ _0: MobecanGenerator<Human> = AsAutoGeneratable<Human>.defaultGenerator,
              age: MobecanGenerator<Int> = AsAutoGeneratable<Int>.defaultGenerator
            ) -> Generator_human {
              .init {
                Builtin(_0, age: age).generate(factory: $0)
              }
            }
          }
          var `case`: MobecanGenerator<Cases>
          var animal: Generator_animal
          var human: Generator_human
          public init(case: MobecanGenerator<Cases> = .unsafeEither(Cases.allCases),
                      animal: Generator_animal = .builtin(),
                      human: Generator_human = .builtin()) {
            self.`case` = `case`
            self.animal = animal
            self.human = human
            super.init()
          }
          public static func using(case: MobecanGenerator<Cases> = .unsafeEither(Cases.allCases),
                                   animal: Generator_animal = .builtin(),
                                   human: Generator_human = .builtin()) -> BuiltinGenerator {
            .init(case: `case`, animal: animal, human: human)
          }
          override public func generate(factory: GeneratorsFactory) -> Single<GeneratorResult<Subject>> {
            factory
              .generate(via: `case`)
              .flatMapSuccess { [animal, human] in
                switch $0 {
                case .legalPerson:
                  return .just(.success(.legalPerson))
                case .animal:
                  return animal.generate(factory: factory).mapSuccess {
                    .animal($0)
                  }
                case .human:
                  return human.generate(factory: factory).mapSuccess {
                    .human($0.0, age: $0.age)
                  }
                }
              }
          }
        }
      }

      extension Subject: AutoGeneratable where Animal: AutoGeneratable, Human: AutoGeneratable {

        static var defaultGenerator: BuiltinGenerator {
          .init()
        }
      }
      """
    )
  }

  func testEnumWithCaseNameDuplicates() {
    checkThat(
      code: """
      @DerivesAutoGeneratable
      enum Bad {
        case voice(Int)
        case voice(String, pitch: Double)
      }
      """,
      expandsTo: """
      enum Bad {
        case voice(Int)
        case voice(String, pitch: Double)
      }
      """,
      withDiagnostics: [
        .init(
          message: "Макрос @DerivesAutoGeneratable не поддерживает енумы с одноимёнными кейсами.",
          line: 3,
          column: 8
        ),
        .init(
          message: "Макрос @DerivesAutoGeneratable не поддерживает енумы с одноимёнными кейсами.",
          line: 4,
          column: 8
        )
      ]
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
