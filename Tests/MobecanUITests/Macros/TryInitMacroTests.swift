// Copyright © 2024 Mobecan. All rights reserved.

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MobecanUI


final class TryInitMacroTests: MacrosTester {

  func testEmptyStruct() {
    checkThat(
      code: "@TryInit struct Empty {}",
      expandsTo: "struct Empty {}"
    )
  }

  func testEmptyClass() {
    checkThat(
      code: "@TryInit class Empty {}",
      expandsTo: "class Empty {}"
    )
  }

  func testSimpleStruct() {
    checkThat(
      code: """
      @TryInit
      struct Pair {

        var first: String
        var second: Int

        init(first: String,
             second: Int) {
          self.first = first
          self.second = second
        }
      }
      """,
      expandsTo: """
      struct Pair {

        var first: String
        var second: Int

        init(first: String,
             second: Int) {
          self.first = first
          self.second = second
        }

        static func tryInit<SomeError: ComposableError>(
          first: Result<String, SomeError>,
          second: Result<Int, SomeError>
        ) -> Result<Pair, SomeError> {
          var errors: [String: SomeError] = [:]
          first.asError.map {
            errors["first"] = $0
          }
          second.asError.map {
            errors["second"] = $0
          }
          if let nonEmptyErrors = NonEmpty(rawValue: errors) {
            return .failure(.composed(from: nonEmptyErrors))
          }
          return .success(
            .init(
              first: try! first.get() /* swiftlint:disable:this force_try */,
              second: try! second.get() /* swiftlint:disable:this force_try */
            )
          )
        }
      }
      """
    )
  }

  func testComplexStruct() {
    checkThat(
      code: """
      @TryInit
      struct Pair {

        let zero = 0
        var first: String?
        var second: Bool
        lazy var third = 3.14
        var fourth: Decimal = .init(999.90)
      }
      """,
      expandsTo: """
      struct Pair {

        let zero = 0
        var first: String?
        var second: Bool
        lazy var third = 3.14
        var fourth: Decimal = .init(999.90)

        static func tryInit<SomeError: ComposableError>(
          first: Result<String?, SomeError> = .success(nil),
          second: Result<Bool, SomeError>,
          fourth: Result<Decimal, SomeError> = .success(.init(999.90))
        ) -> Result<Pair, SomeError> {
          var errors: [String: SomeError] = [:]
          first.asError.map {
            errors["first"] = $0
          }
          second.asError.map {
            errors["second"] = $0
          }
          fourth.asError.map {
            errors["fourth"] = $0
          }
          if let nonEmptyErrors = NonEmpty(rawValue: errors) {
            return .failure(.composed(from: nonEmptyErrors))
          }
          return .success(
            .init(
              first: try! first.get() /* swiftlint:disable:this force_try */,
              second: try! second.get() /* swiftlint:disable:this force_try */,
              fourth: try! fourth.get() /* swiftlint:disable:this force_try */
            )
          )
        }
      }
      """
    )
  }

  func testComplexClass() {
    checkThat(
      code: """
      @TryInit
      open class Pair<Third, Fourth> {

        var first: String?
        var second: Int
        var third: Third? = nil

        private init(_ first: String? = nil,
                     _: Bool = false,
                     second: Int) {
          self.first = first
          self.second = second
          self.third = nil
        }

        init!(_ first: String?,
              second: Int) throws {
          self.first = first
          self.second = second
        }

        public required init?(firstAndSecond: (String?, Int) = ("", 333),
                              third: Third,
                              fourth: Fourth? = nil) throws {
          self.first = first
          self.second = second
          self.third = third
        }
      }
      """,
      expandsTo: """
      open class Pair<Third, Fourth> {

        var first: String?
        var second: Int
        var third: Third? = nil

        private init(_ first: String? = nil,
                     _: Bool = false,
                     second: Int) {
          self.first = first
          self.second = second
          self.third = nil
        }

        init!(_ first: String?,
              second: Int) throws {
          self.first = first
          self.second = second
        }

        public required init?(firstAndSecond: (String?, Int) = ("", 333),
                              third: Third,
                              fourth: Fourth? = nil) throws {
          self.first = first
          self.second = second
          self.third = third
        }

        private static func tryInit<SomeError: ComposableError>(
          _ first: Result<String?, SomeError> = .success(nil),
          _ _1: Bool = false,
          second: Result<Int, SomeError>
        ) -> Result<Pair, SomeError> {
          var errors: [String: SomeError] = [:]
          first.asError.map {
            errors["first"] = $0
          }
          second.asError.map {
            errors["second"] = $0
          }
          if let nonEmptyErrors = NonEmpty(rawValue: errors) {
            return .failure(.composed(from: nonEmptyErrors))
          }
          return .success(
            .init(
              try! first.get() /* swiftlint:disable:this force_try */,
              _1,
              second: try! second.get() /* swiftlint:disable:this force_try */
            )
          )
        }

        static func tryInit<SomeError: ComposableError>(
          _ first: Result<String?, SomeError>,
          second: Result<Int, SomeError>
        ) throws -> Result<Pair, SomeError> {
          var errors: [String: SomeError] = [:]
          first.asError.map {
            errors["first"] = $0
          }
          second.asError.map {
            errors["second"] = $0
          }
          if let nonEmptyErrors = NonEmpty(rawValue: errors) {
            return .failure(.composed(from: nonEmptyErrors))
          }
          return try .success(
            .init(
              try! first.get() /* swiftlint:disable:this force_try */,
              second: try! second.get() /* swiftlint:disable:this force_try */
            )
          )
        }

        public static func tryInit<SomeError: ComposableError>(
          firstAndSecond: Result<(String?, Int), SomeError> = .success(("", 333)),
          third: Result<Third, SomeError>,
          fourth: Result<Fourth?, SomeError> = .success(nil)
        ) throws -> Result<Pair?, SomeError> {
          var errors: [String: SomeError] = [:]
          firstAndSecond.asError.map {
            errors["firstAndSecond"] = $0
          }
          third.asError.map {
            errors["third"] = $0
          }
          fourth.asError.map {
            errors["fourth"] = $0
          }
          if let nonEmptyErrors = NonEmpty(rawValue: errors) {
            return .failure(.composed(from: nonEmptyErrors))
          }
          return try .success(
            .init(
              firstAndSecond: try! firstAndSecond.get() /* swiftlint:disable:this force_try */,
              third: try! third.get() /* swiftlint:disable:this force_try */,
              fourth: try! fourth.get() /* swiftlint:disable:this force_try */
            )
          )
        }
      }
      """
    )
  }
}
