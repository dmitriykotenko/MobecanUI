import XCTest

import LayoutKit
import RxCocoa
import RxCocoaRuntime
import RxSwift
import RxTest
import SnapKit
import UIKit

@testable import MobecanUI


class SizableViewFixedWidthFixedHeightTests: SizableViewTester {

  func testFixedWidth() {
    _ = (1...1000)
      .map { _ in
        let fixedWidth = CGFloat.randomUiDimension()
        return Test(
          widthRestrictions: .init(min: fixedWidth, max: fixedWidth)
        )
      }
      .prefix {
        isEqual(
          test: $0,
          actual: $0.sizeThatFits.width,
          expected: $0.widthRestrictions.min ?? 0,
          errorMessage: { "Actual width \($0) is not equal to only possible width \($1)" }
        )
      }
  }

  func testFixedHeight() {
    _ = (1...1000)
      .map { _ in
        let fixedHeight = CGFloat.randomUiDimension()
        return Test(
          heightRestrictions: .init(min: fixedHeight, max: fixedHeight)
        )
      }
      .prefix {
        isEqual(
          test: $0,
          actual: $0.sizeThatFits.height,
          expected: $0.heightRestrictions.min ?? 0,
          errorMessage: { "Actual height \($0) is not equal to only possible height \($1)" }
        )
      }
  }
}
