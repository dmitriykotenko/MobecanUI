// Copyright © 2024 Mobecan. All rights reserved.

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MobecanUI


extension TryInitMacroTests {

  func testMultipleInits() {
    checkThat(
      code: """
      @TryInit
      open class Container {

        var value: String?

        init(_ value: String? = nil) {
          self.value = value
        }

        init(lines: [String]) {
          self.value = lines.mkString()
        }

        init!(_ value: String?) throws {
          self.value = value
        }
      }
      """,
      expandsTo: """
      open class Container {

        var value: String?

        init(_ value: String? = nil) {
          self.value = value
        }

        init(lines: [String]) {
          self.value = lines.mkString()
        }

        init!(_ value: String?) throws {
          self.value = value
        }

        static func tryInit<
          SomeError: ComposableError
        >(
          _ value: Result<String?, SomeError> = .success(nil)
        ) -> Result<Container, SomeError> {
          var errors: [String: SomeError] = [:]
          value.asError.map {
            errors["value"] = $0
          }
          if let nonEmptyErrors = NonEmpty(rawValue: errors) {
            return .failure(.composed(from: nonEmptyErrors))
          }
          // swiftlint:disable force_try
          return .success(
            .init(
              try! value.get()
            )
          )
          // swiftlint:enable force_try
        }

        static func tryInit<
          SomeError: ComposableError
        >(
          lines: Result<[String], SomeError>
        ) -> Result<Container, SomeError> {
          var errors: [String: SomeError] = [:]
          lines.asError.map {
            errors["lines"] = $0
          }
          if let nonEmptyErrors = NonEmpty(rawValue: errors) {
            return .failure(.composed(from: nonEmptyErrors))
          }
          // swiftlint:disable force_try
          return .success(
            .init(
              lines: try! lines.get()
            )
          )
          // swiftlint:enable force_try
        }

        static func tryInit<
          SomeError: ComposableError
        >(
          _ value: Result<String?, SomeError>
        ) throws -> Result<Container, SomeError> {
          var errors: [String: SomeError] = [:]
          value.asError.map {
            errors["value"] = $0
          }
          if let nonEmptyErrors = NonEmpty(rawValue: errors) {
            return .failure(.composed(from: nonEmptyErrors))
          }
          // swiftlint:disable force_try
          return try .success(
            .init(
              try! value.get()
            )
          )
          // swiftlint:enable force_try
        }
      }
      """
    )
  }
}
