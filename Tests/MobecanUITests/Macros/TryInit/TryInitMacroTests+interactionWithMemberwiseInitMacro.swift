// Copyright © 2024 Mobecan. All rights reserved.

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MobecanUI


extension TryInitMacroTests {

  func testInteractionWithMemberwiseInitMacro1() {
    checkThat(
      code: """
      @MemberwiseInit
      @TryInit
      public struct Triple {
        var first: String?
        var second: Bool
        var third: (Int) -> Bool = { $0 % 2 == 0 }
      }
      """,
      expandsTo: """
      public struct Triple {
        var first: String?
        var second: Bool
        var third: (Int) -> Bool = { $0 % 2 == 0 }

        public init(
          first: String? = nil,
          second: Bool,
          third: @escaping (Int) -> Bool = {
            $0 % 2 == 0
          }
        ) {
          self.first = first
          self.second = second
          self.third = third
        }

        public static func tryInit<
          SomeError: ComposableError
        >(
          first: Result<String?, SomeError> = .success(nil),
          second: Result<Bool, SomeError>,
          third: Result<(Int) -> Bool, SomeError> = .success({
              $0 % 2 == 0
            })
        ) -> Result<Triple, SomeError> {
          var errors: [String: SomeError] = [:]
          first.asError.map {
            errors["first"] = $0
          }
          second.asError.map {
            errors["second"] = $0
          }
          third.asError.map {
            errors["third"] = $0
          }
          if let nonEmptyErrors = NonEmpty(rawValue: errors) {
            return .failure(.composed(from: nonEmptyErrors))
          }
          // swiftlint:disable force_try
          return .success(
            .init(
              first: try! first.get(),
              second: try! second.get(),
              third: try! third.get()
            )
          )
          // swiftlint:enable force_try
        }
      }
      """
    )
  }

  func testInteractionWithMemberwiseInitMacro2() {
    checkThat(
      code: """
      @MemberwiseInit
      @TryInit
      public struct Triple {
        var first: String?
        var second: Bool
        var third: (Int) -> Bool = { $0 % 2 == 0 }

        init(abc: Double) {
          self.first = nil
          self.second = false
          self.third =  { _ in false }
        }
      }
      """,
      expandsTo: """
      public struct Triple {
        var first: String?
        var second: Bool
        var third: (Int) -> Bool = { $0 % 2 == 0 }

        init(abc: Double) {
          self.first = nil
          self.second = false
          self.third =  { _ in false }
        }

        public init(
          first: String? = nil,
          second: Bool,
          third: @escaping (Int) -> Bool = {
            $0 % 2 == 0
          }
        ) {
          self.first = first
          self.second = second
          self.third = third
        }

        static func tryInit<
          SomeError: ComposableError
        >(
          abc: Result<Double, SomeError>
        ) -> Result<Triple, SomeError> {
          var errors: [String: SomeError] = [:]
          abc.asError.map {
            errors["abc"] = $0
          }
          if let nonEmptyErrors = NonEmpty(rawValue: errors) {
            return .failure(.composed(from: nonEmptyErrors))
          }
          // swiftlint:disable force_try
          return .success(
            .init(
              abc: try! abc.get()
            )
          )
          // swiftlint:enable force_try
        }

        public static func tryInit<
          SomeError: ComposableError
        >(
          first: Result<String?, SomeError> = .success(nil),
          second: Result<Bool, SomeError>,
          third: Result<(Int) -> Bool, SomeError> = .success({
              $0 % 2 == 0
            })
        ) -> Result<Triple, SomeError> {
          var errors: [String: SomeError] = [:]
          first.asError.map {
            errors["first"] = $0
          }
          second.asError.map {
            errors["second"] = $0
          }
          third.asError.map {
            errors["third"] = $0
          }
          if let nonEmptyErrors = NonEmpty(rawValue: errors) {
            return .failure(.composed(from: nonEmptyErrors))
          }
          // swiftlint:disable force_try
          return .success(
            .init(
              first: try! first.get(),
              second: try! second.get(),
              third: try! third.get()
            )
          )
          // swiftlint:enable force_try
        }
      }
      """
    )
  }
}
