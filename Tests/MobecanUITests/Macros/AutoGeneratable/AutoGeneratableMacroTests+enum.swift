// Copyright © 2024 Mobecan. All rights reserved.

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MobecanUI

import RxSwift
import RxTest
import RxBlocking


extension AutoGeneratableMacroTests {

  func testSimpleEnum() {
    checkThat(
      code: """
      @DerivesAutoGeneratable
      internal enum Medal {
        case gold
        case silver
        case bronze
      }
      """,
      expandsTo: """
      internal enum Medal {
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
      fileprivate enum Medal {
        case gold, silver, bronze
      }
      """,
      expandsTo: """
      fileprivate enum Medal {
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
      public enum Subject<Animal, Human> {
        case legalPerson
        case animal(Animal)
        case human(Human, age: Int)
      }
      """,
      expandsTo: """
      public enum Subject<Animal, Human> {
        case legalPerson
        case animal(Animal)
        case human(Human, age: Int)

        public class BuiltinGenerator: MobecanGenerator<Subject>
        where Animal: AutoGeneratable, Human: AutoGeneratable {

          public enum Cases: CaseIterable {
            case legalPerson
            case animal
            case human
          }
          public class Generator_animal: FunctionalGenerator<Animal> {
            public class Builtin: MobecanGenerator<Animal> {
              public var _0: MobecanGenerator<Animal>
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
            public static func builtin(
              _ _0: MobecanGenerator<Animal> = AsAutoGeneratable<Animal>.defaultGenerator
            ) -> Generator_animal {
              .init {
                Builtin(_0).generate(factory: $0)
              }
            }
          }
          public class Generator_human: FunctionalGenerator<(Human, age: Int)> {
            public class Builtin: MobecanGenerator<(Human, age: Int)> {
              public var _0: MobecanGenerator<Human>
              public var age: MobecanGenerator<Int>
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
              override public func generate(
                factory: GeneratorsFactory
              ) -> Single<GeneratorResult<(Human, age: Int)>> {
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
            public static func builtin(
              _ _0: MobecanGenerator<Human> = AsAutoGeneratable<Human>.defaultGenerator,
              age: MobecanGenerator<Int> = AsAutoGeneratable<Int>.defaultGenerator
            ) -> Generator_human {
              .init {
                Builtin(_0, age: age).generate(factory: $0)
              }
            }
          }
          public var `case`: MobecanGenerator<Cases>
          public var animal: Generator_animal
          public var human: Generator_human
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

        public static var defaultGenerator: BuiltinGenerator {
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
}
