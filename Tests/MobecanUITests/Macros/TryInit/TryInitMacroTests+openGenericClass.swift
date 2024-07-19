// Copyright © 2024 Mobecan. All rights reserved.

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MobecanUI


extension TryInitMacroTests {

  func testOpenGenericClass() {
    checkThat(
      code: """
      @TryInit
      open class Pair<Third, Fourth> {

        var first: String?
        var second: Int
        var third: Third? = nil

        private required init?(firstAndSecond: (String?, Int) = ("", 333),
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

        private required init?(firstAndSecond: (String?, Int) = ("", 333),
                               third: Third,
                               fourth: Fourth? = nil) throws {
          self.first = first
          self.second = second
          self.third = third
        }

        private static func tryInit<
          SomeError: ComposableError
        >(
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
