import XCTest

import LayoutKit
import RxCocoa
import RxCocoaRuntime
import RxSwift
import RxTest
import SnapKit
import UIKit

@testable import MobecanUI


class SizableViewHeightRestrictionsTests: SizableViewTester {

  func testMinimumHeight1() {
    _ = (1...1000)
      .map { _ in
        Test(
          nativeHeight: 0,
          heightRestrictions: .random(min: .randomUiDimension()),
          mustStretchVertically: false
        )
      }
      .prefix {
        isEqual(
          test: $0,
          actual: $0.sizeThatFits.height,
          expected: $0.heightRestrictions.min ?? .greatestFiniteMagnitude,
          errorMessage: { "Actual height \($0) is less than minimum possible height \($1)" }
        )
      }
  }

  func testMinimumHeight2() {
    _ = (1...1000)
      .map { _ in
        Test(
          heightRestrictions: .random(min: .randomUiDimension())
        )
      }
      .prefix {
        isGreater(
          test: $0,
          actual: $0.sizeThatFits.height,
          expected: $0.heightRestrictions.min ?? .greatestFiniteMagnitude,
          errorMessage: { "Actual height \($0) is less than minimum possible height \($1)" }
        )
      }
  }

  func testMaximumHeight1() {
    _ = (1...1000)
      .map { _ in
        Test(
          nativeHeight: .greatestFiniteMagnitude,
          heightRestrictions: .random(max: .randomUiDimension()),
          mustStretchVertically: false
        )
      }
      .prefix {
        isEqual(
          test: $0,
          actual: $0.sizeThatFits.height,
          expected: $0.heightRestrictions.max ?? 0,
          errorMessage: { "Actual height \($0) is greater than maximum possible height \($1)" }
        )
      }
  }

  func testMaximumHeight2() {
    _ = (1...1000)
      .map { _ in
        Test(
          heightRestrictions: .random(max: .randomUiDimension())
        )
      }
      .prefix {
        isLess(
          test: $0,
          actual: $0.sizeThatFits.height,
          expected: $0.heightRestrictions.max ?? .greatestFiniteMagnitude,
          errorMessage: { "Actual height \($0) is greater than maximum possible height \($1)" }
        )
      }
  }
}
