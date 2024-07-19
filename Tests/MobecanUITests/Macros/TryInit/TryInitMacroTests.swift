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

        static func tryInit<
          SomeError: ComposableError
        >(
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
          // swiftlint:disable force_try
          return .success(
            .init(
              first: try! first.get(),
              second: try! second.get()
            )
          )
          // swiftlint:enable force_try
        }
      }
      """
    )
  }
}
