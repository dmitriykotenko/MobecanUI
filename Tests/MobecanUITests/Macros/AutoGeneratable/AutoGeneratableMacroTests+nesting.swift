// Copyright © 2024 Mobecan. All rights reserved.

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MobecanUI

import RxSwift
import RxTest
import RxBlocking


extension AutoGeneratableMacroTests {

  func testNestedStruct1() {
    checkThat(
      code: """
      public struct A {
        @DerivesAutoGeneratable struct B {
        }
      }
      """,
      expandsTo: """
      public struct A {
        struct B {

          class BuiltinGenerator: MobecanGenerator<B> {

            override func generate(factory: GeneratorsFactory) -> Single<GeneratorResult<B>> {
              .just(.success(B()))
            }
          }
        }
      }

      extension A.B: AutoGeneratable {

        static var defaultGenerator: BuiltinGenerator {
          .init()
        }
      }
      """
    )
  }

  func testNestedStruct2() {
    checkThat(
      code: """
      public struct A {
        struct B {
          @DerivesAutoGeneratable struct C {
          }
        }
      }
      """,
      expandsTo: """
      public struct A {
        struct B {
          struct C {

            class BuiltinGenerator: MobecanGenerator<C> {

              override func generate(factory: GeneratorsFactory) -> Single<GeneratorResult<C>> {
                .just(.success(C()))
              }
            }
          }
        }
      }

      extension A.B.C: AutoGeneratable {

        static var defaultGenerator: BuiltinGenerator {
          .init()
        }
      }
      """
    )
  }

  func testNestedStruct3() {
    checkThat(
      code: """
      extension A {
        @DerivesAutoGeneratable public struct B {
        }
      }
      """,
      expandsTo: """
      extension A {
        public struct B {

          public class BuiltinGenerator: MobecanGenerator<B> {

            override public func generate(factory: GeneratorsFactory) -> Single<GeneratorResult<B>> {
              .just(.success(B()))
            }
          }
        }
      }

      extension A.B: AutoGeneratable {

        public static var defaultGenerator: BuiltinGenerator {
          .init()
        }
      }
      """
    )
  }

  func testNestedStruct4() {
    checkThat(
      code: """
      public struct A {
        struct B {
          @DerivesAutoGeneratable struct C {
          }
        }
      }
      """,
      expandsTo: """
      public struct A {
        struct B {
          struct C {

            class BuiltinGenerator: MobecanGenerator<C> {

              override func generate(factory: GeneratorsFactory) -> Single<GeneratorResult<C>> {
                .just(.success(C()))
              }
            }
          }
        }
      }

      extension A.B.C: AutoGeneratable {

        static var defaultGenerator: BuiltinGenerator {
          .init()
        }
      }
      """
    )
  }

  func testNestedEnum() {
    checkThat(
      code: """
      public struct A {}

      extension A {
        @DerivesAutoGeneratable public enum B {
          case instance(string: String, int: Int)
        }
      }
      """,
      expandsTo: """
      public struct A {}

      extension A {
        public enum B {
          case instance(string: String, int: Int)

          public class BuiltinGenerator: MobecanGenerator<B> {

            public enum Cases: CaseIterable {
              case instance
            }
            public class Generator_instance: FunctionalGenerator<(string: String, int: Int)> {
              public class Builtin: MobecanGenerator<(string: String, int: Int)> {
                public var string: MobecanGenerator<String>
                public var int: MobecanGenerator<Int>
                public init(string: MobecanGenerator<String> = AsAutoGeneratable<String>.defaultGenerator,
                            int: MobecanGenerator<Int> = AsAutoGeneratable<Int>.defaultGenerator) {
                  self.string = string
                  self.int = int
                  super.init()
                }
                public static func using(
                  string: MobecanGenerator<String> = AsAutoGeneratable<String>.defaultGenerator,
                  int: MobecanGenerator<Int> = AsAutoGeneratable<Int>.defaultGenerator
                ) -> Builtin {
                  .init(string: string, int: int)
                }
                override public func generate(
                  factory: GeneratorsFactory
                ) -> Single<GeneratorResult<(string: String, int: Int)>> {
                  Single
                    .zip(
                      factory.generate(via: string),
                      factory.generate(via: int)
                    )
                    .map {
                      zip($0, $1)
                    }
                    .mapSuccess {
                      (string: $0, int: $1)
                    }
                }
              }
              public static func builtin(
                string: MobecanGenerator<String> = AsAutoGeneratable<String>.defaultGenerator,
                int: MobecanGenerator<Int> = AsAutoGeneratable<Int>.defaultGenerator
              ) -> Generator_instance {
                .init {
                  Builtin(string: string, int: int).generate(factory: $0)
                }
              }
            }
            public var `case`: MobecanGenerator<Cases>
            public var instance: Generator_instance
            public init(case: MobecanGenerator<Cases> = .unsafeEither(Cases.allCases),
                        instance: Generator_instance = .builtin()) {
              self.`case` = `case`
              self.instance = instance
              super.init()
            }
            public static func using(case: MobecanGenerator<Cases> = .unsafeEither(Cases.allCases),
                                     instance: Generator_instance = .builtin()) -> BuiltinGenerator {
              .init(case: `case`, instance: instance)
            }
            override public func generate(factory: GeneratorsFactory) -> Single<GeneratorResult<B>> {
              factory
                .generate(via: `case`)
                .flatMapSuccess { [instance] in
                  switch $0 {
                  case .instance:
                    return instance.generate(factory: factory).mapSuccess {
                      .instance(string: $0.string, int: $0.int)
                    }
                  }
                }
            }
          }
        }
      }

      extension A.B: AutoGeneratable {

        public static var defaultGenerator: BuiltinGenerator {
          .init()
        }
      }
      """
    )
  }
}
