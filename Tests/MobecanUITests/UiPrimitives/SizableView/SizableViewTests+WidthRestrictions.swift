import XCTest

import LayoutKit
import RxCocoa
import RxCocoaRuntime
import RxSwift
import RxTest
import SnapKit
import UIKit

@testable import MobecanUI


class SizableViewWidthRestrictionsTests: SizableViewTester {

  func testMinimumWidth1() {
    _ = (1...1000)
      .map { _ in
        Test(
          nativeWidth: 0,
          widthRestrictions: .random(min: .randomUiDimension()),
          mustStretchHorizontally: false
        )
      }
      .prefix {
        isEqual(
          test: $0,
          actual: $0.sizeThatFits.width,
          expected: $0.widthRestrictions.min ?? .greatestFiniteMagnitude,
          errorMessage: { "Actual width \($0) is less than minimum possible width \($1)" }
        )
      }
  }

  func testMinimumWidth2() {
    _ = (1...1000)
      .map { _ in
        Test(
          widthRestrictions: .random(min: .randomUiDimension())
        )
      }
      .prefix {
        isGreater(
          test: $0,
          actual: $0.sizeThatFits.width,
          expected: $0.widthRestrictions.min ?? .greatestFiniteMagnitude,
          errorMessage: { "Actual width \($0) is less than minimum possible width \($1)" }
        )
      }
  }

  func testMaximumWidth1() {
    _ = (1...1000)
      .map { _ in
        Test(
          nativeWidth: .greatestFiniteMagnitude,
          widthRestrictions: .random(max: .randomUiDimension()),
          mustStretchHorizontally: false
        )
      }
      .prefix {
        isEqual(
          test: $0,
          actual: $0.sizeThatFits.width,
          expected: $0.widthRestrictions.max ?? 0,
          errorMessage: { "Actual width \($0) is greater than maximum possible width \($1)" }
        )
      }
  }

  func testMaximumWidth2() {
    _ = (1...1000)
      .map { _ in
        Test(
          widthRestrictions: .random(max: .randomUiDimension())
        )
      }
      .prefix {
        isLess(
          test: $0,
          actual: $0.sizeThatFits.width,
          expected: $0.widthRestrictions.max ?? .greatestFiniteMagnitude,
          errorMessage: { "Actual width \($0) is greater than maximum possible width \($1)" }
        )
      }
  }
}
