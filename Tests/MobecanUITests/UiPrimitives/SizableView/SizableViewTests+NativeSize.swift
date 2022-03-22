import XCTest

import LayoutKit
import RxCocoa
import RxCocoaRuntime
import RxSwift
import RxTest
import SnapKit
import UIKit

@testable import MobecanUI


class SizableViewNativeSizeTests: SizableViewTester {

  func testNativeWidth1() {
    _ = (1...1000)
      .map { _ in
        Test(
          widthRestrictions: .init(min: nil, max: nil),
          mustStretchHorizontally: false
        )
      }
      .prefix {
        isEqual(
          test: $0,
          actual: $0.sizeThatFits.width,
          expected: $0.nativeSize.width,
          errorMessage: { "Actual width \($0) != expected native width \($1)" }
        )
      }
  }

  func testNativeWidth2() {
    _ = (1...1000)
      .map { _ in
        let array: [CGFloat] =
          [.randomUiDimension(), .randomUiDimension(), .randomUiDimension()].sorted(by: <)

        return Test(
          nativeWidth: array[1],
          widthRestrictions: .init(
            min: Bool.random() ? array[0] : nil,
            max: Bool.random() ? array[2] : nil
          ),
          mustStretchHorizontally: false
        )
      }
      .prefix {
        isEqual(
          test: $0,
          actual: $0.sizeThatFits.width,
          expected: $0.nativeSize.width,
          errorMessage: { "Actual width \($0) != expected native width \($1)" }
        )
      }
  }

  func testNativeHeight1() {
    _ = (1...1000)
      .map { _ in
        Test(
          heightRestrictions: .init(min: nil, max: nil),
          mustStretchVertically: false
        )
      }
      .prefix {
        isEqual(
          test: $0,
          actual: $0.sizeThatFits.height,
          expected: $0.nativeSize.height,
          errorMessage: { "Actual height \($0) != expected native height \($1)" }
        )
      }
  }

  func testNativeHeight2() {
    _ = (1...1000)
      .map { _ in
        let array: [CGFloat] =
          [.randomUiDimension(), .randomUiDimension(), .randomUiDimension()].sorted(by: <)

        return Test(
          nativeHeight: array[1],
          heightRestrictions: .init(
            min: Bool.random() ? array[0] : nil,
            max: Bool.random() ? array[2] : nil
          ),
          mustStretchVertically: false
        )
      }
      .prefix {
        isEqual(
          test: $0,
          actual: $0.sizeThatFits.height,
          expected: $0.nativeSize.height,
          errorMessage: { "Actual height \($0) != expected native height \($1)" }
        )
      }
  }
}
