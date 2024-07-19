// Copyright © 2024 Mobecan. All rights reserved.

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MobecanUI


extension TryInitMacroTests {

  func testComplexImplicitInit() {
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

        static func tryInit<
          SomeError: ComposableError
        >(
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
}
