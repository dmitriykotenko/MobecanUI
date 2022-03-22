import XCTest

import LayoutKit
import RxCocoa
import RxCocoaRuntime
import RxSwift
import RxTest
import SnapKit
import UIKit

@testable import MobecanUI


class SizableViewStretchableHeightTests: SizableViewTester {

  func testStretchableHeight1() {
    _ = (1...1000)
      .map { _ in
        Test(
          heightRestrictions: .init(min: nil, max: nil),
          mustStretchVertically: true
        )
      }
      .prefix {
        isEqual(
          test: $0,
          actual: $0.sizeThatFits.height,
          expected: $0.sizeToFit.height,
          errorMessage: { "Actual height \($0) != sizeToFit's height \($1)" }
        )
      }
  }

  func testStretchableHeight2() {
    _ = (1...1000)
      .map { _ in
        let array: [CGFloat] =
          [.randomUiDimension(), .randomUiDimension()].sorted(by: <)

        return Test(
          heightRestrictions: .init(min: array[1], max: nil),
          mustStretchVertically: true,
          sizeToFit: .random(height: array[0])
        )
      }
      .prefix {
        isEqual(
          test: $0,
          actual: $0.sizeThatFits.height,
          expected: $0.heightRestrictions.min ?? .greatestFiniteMagnitude,
          errorMessage: { "Actual height \($0) != minimum possible height \($1)" }
        )
      }
  }

  func testStretchableHeight3() {
    _ = (1...1000)
      .map { _ in
        let array: [CGFloat] =
          [.randomUiDimension(), .randomUiDimension()].sorted(by: <)

        return Test(
          heightRestrictions: .init(min: nil, max: array[0]),
          mustStretchVertically: true,
          sizeToFit: .random(height: array[1])
        )
      }
      .prefix {
        isEqual(
          test: $0,
          actual: $0.sizeThatFits.height,
          expected: $0.heightRestrictions.max ?? 0,
          errorMessage: { "Actual height \($0) != maximum possible height \($1)" }
        )
      }
  }

  func testStretchableHeight4() {
    _ = (1...1000)
      .map { _ in
        let array: [CGFloat] =
          [.randomUiDimension(), .randomUiDimension(), .randomUiDimension()].sorted(by: <)

        return Test(
          heightRestrictions: .init(
            min: Bool.random() ? array[0] : nil,
            max: Bool.random() ? array[2] : nil
          ),
          mustStretchVertically: true,
          sizeToFit: .random(height: array[1])
        )
      }
      .prefix {
        isEqual(
          test: $0,
          actual: $0.sizeThatFits.height,
          expected: $0.sizeToFit.height,
          errorMessage: { "Actual height \($0) != sizeToFit's height \($1)" }
        )
      }
  }
}
