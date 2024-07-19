// Copyright © 2024 Mobecan. All rights reserved.

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MobecanUI


extension TryInitMacroTests {

  func testInitWithAnonymousParameters() {
    checkThat(
      code: """
      @TryInit
      open class Pair<Third, Fourth> {

        var first: String?
        var second: Int
        var third: Third? = nil

        fileprivate init(_ first: String? = nil,
                         _: Bool = false,
                         second: Int) {
          self.first = first
          self.second = second
          self.third = nil
        }
      }
      """,
      expandsTo: """
      open class Pair<Third, Fourth> {

        var first: String?
        var second: Int
        var third: Third? = nil

        fileprivate init(_ first: String? = nil,
                         _: Bool = false,
                         second: Int) {
          self.first = first
          self.second = second
          self.third = nil
        }

        fileprivate static func tryInit<
          SomeError: ComposableError
        >(
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
      }
      """
    )
  }

  func testInitWithOnlyAnonymousParameters() {
    checkThat(
      code: """
      @TryInit
      open class Pair<Third, Fourth> {

        var first: String?
        var second: Int
        var third: Third? = nil

        init(first _: String? = nil,
             _: Bool = false,
             _ _: Float = 0.5) {
          self.first = first
          self.second = 333
        }
      }
      """,
      expandsTo: """
      open class Pair<Third, Fourth> {

        var first: String?
        var second: Int
        var third: Third? = nil

        init(first _: String? = nil,
             _: Bool = false,
             _ _: Float = 0.5) {
          self.first = first
          self.second = 333
        }
      }
      """
    )
  }
}
