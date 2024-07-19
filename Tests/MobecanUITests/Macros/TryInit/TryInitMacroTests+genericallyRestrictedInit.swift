// Copyright © 2024 Mobecan. All rights reserved.

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MobecanUI


extension TryInitMacroTests {

  func testGenericallyRestrictedInit() {
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

        public init<Element: Equatable>(elements: [Element]) where Third == [Element] {
          self.first = ""
          self.second = 55555
          self.third = elements
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

        public init<Element: Equatable>(elements: [Element]) where Third == [Element] {
          self.first = ""
          self.second = 55555
          self.third = elements
        }

        private static func tryInit<
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

        public static func tryInit<
          Element: Equatable,
          SomeError: ComposableError
        >(
          elements: Result<[Element], SomeError>
        ) -> Result<Pair, SomeError>
        where Third == [Element] {
          var errors: [String: SomeError] = [:]
          elements.asError.map {
            errors["elements"] = $0
          }
          if let nonEmptyErrors = NonEmpty(rawValue: errors) {
            return .failure(.composed(from: nonEmptyErrors))
          }
          return .success(
            .init(
              elements: try! elements.get() /* swiftlint:disable:this force_try */
            )
          )
        }
      }
      """
    )
  }
}
