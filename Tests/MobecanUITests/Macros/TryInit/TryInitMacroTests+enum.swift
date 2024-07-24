// Copyright © 2024 Mobecan. All rights reserved.

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MobecanUI


extension TryInitMacroTests {

  func testTryInitForTrivialEnum() {
    checkThat(
      code: """
      @TryInit
      public enum Currency {
        case roubles
        case euros
      }
      """,
      expandsTo: """
      public enum Currency {
        case roubles
        case euros
      }
      """
    )
  }

  func testTryInitObjectForNonTrivialEnum() {
    checkThat(
      code: """
      @TryInit
      public enum Money {
        case nothing
        case roubles(Int)
        case euros(amount: Int, fakeness: Double)
        case pounds(Int, royalness: Double = 999)

        private init(euros: Int) {
          self = .euros(amount: euros, fakeness: 1)
        }
      }
      """,
      expandsTo: """
      public enum Money {
        case nothing
        case roubles(Int)
        case euros(amount: Int, fakeness: Double)
        case pounds(Int, royalness: Double = 999)

        private init(euros: Int) {
          self = .euros(amount: euros, fakeness: 1)
        }

        private static func tryInit<
          SomeError: ComposableError
        >(
          euros: Result<Int, SomeError>
        ) -> Result<Money, SomeError> {
          var errors: [String: SomeError] = [:]
          euros.asError.map {
            errors["euros"] = $0
          }
          if let nonEmptyErrors = NonEmpty(rawValue: errors) {
            return .failure(.composed(from: nonEmptyErrors))
          }
          // swiftlint:disable force_try
          return .success(
            .init(
              euros: try! euros.get()
            )
          )
          // swiftlint:enable force_try
        }

        enum tryInit {
          public static func roubles<
            SomeError: ComposableError
          >(
            _ _0: Result<Int, SomeError>
          ) -> Result<Money, SomeError> {
            var errors: [String: SomeError] = [:]
            _0.asError.map {
              errors["_0"] = $0
            }
            if let nonEmptyErrors = NonEmpty(rawValue: errors) {
              return .failure(.composed(from: nonEmptyErrors))
            }
            // swiftlint:disable force_try
            return .success(
              .roubles(
                try! _0.get()
              )
            )
            // swiftlint:enable force_try
          }

          public static func euros<
            SomeError: ComposableError
          >(
            amount: Result<Int, SomeError>,
            fakeness: Result<Double, SomeError>
          ) -> Result<Money, SomeError> {
            var errors: [String: SomeError] = [:]
            amount.asError.map {
              errors["amount"] = $0
            }
            fakeness.asError.map {
              errors["fakeness"] = $0
            }
            if let nonEmptyErrors = NonEmpty(rawValue: errors) {
              return .failure(.composed(from: nonEmptyErrors))
            }
            // swiftlint:disable force_try
            return .success(
              .euros(
                amount: try! amount.get(),
                fakeness: try! fakeness.get()
              )
            )
            // swiftlint:enable force_try
          }

          public static func pounds<
            SomeError: ComposableError
          >(
            _ _0: Result<Int, SomeError>,
            royalness: Result<Double, SomeError>
          ) -> Result<Money, SomeError> {
            var errors: [String: SomeError] = [:]
            _0.asError.map {
              errors["_0"] = $0
            }
            royalness.asError.map {
              errors["royalness"] = $0
            }
            if let nonEmptyErrors = NonEmpty(rawValue: errors) {
              return .failure(.composed(from: nonEmptyErrors))
            }
            // swiftlint:disable force_try
            return .success(
              .pounds(
                try! _0.get(),
                royalness: try! royalness.get()
              )
            )
            // swiftlint:enable force_try
          }
        }
      }
      """
    )
  }
}
