// Copyright © 2024 Mobecan. All rights reserved.

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MobecanUI


extension TryInitMacroTests {

  func testImplicitlyUnwrappedOptionalInit() {
    checkThat(
      code: """
      @TryInit
      open class Pair<Third, Fourth> {

        var first: String?
        var second: Int
        var third: Third? = nil

        init!(_ first: String?,
              second: Int) throws {
          self.first = first
          self.second = second
        }
      }
      """,
      expandsTo: """
      open class Pair<Third, Fourth> {

        var first: String?
        var second: Int
        var third: Third? = nil

        init!(_ first: String?,
              second: Int) throws {
          self.first = first
          self.second = second
        }

        static func tryInit<
          SomeError: ComposableError
        >(
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
      }
      """
    )
  }
}
