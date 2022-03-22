import XCTest

import LayoutKit
import RxCocoa
import RxCocoaRuntime
import RxSwift
import RxTest
import SnapKit
import UIKit

@testable import MobecanUI


class SizableViewStretchableWidthTests: SizableViewTester {

  func testStretchableWidth1() {
    _ = (1...1000)
      .map { _ in
        Test(
          widthRestrictions: .init(min: nil, max: nil),
          mustStretchHorizontally: true
        )
      }
      .prefix {
        isEqual(
          test: $0,
          actual: $0.sizeThatFits.width,
          expected: $0.sizeToFit.width,
          errorMessage: { "Actual width \($0) != sizeToFit's width \($1)" }
        )
      }
  }

  func testStretchableWidth2() {
    _ = (1...1000)
      .map { _ in
        let array: [CGFloat] =
          [.randomUiDimension(), .randomUiDimension()].sorted(by: <)

        return Test(
          widthRestrictions: .init(min: array[1], max: nil),
          mustStretchHorizontally: true,
          sizeToFit: .random(width: array[0])
        )
      }
      .prefix {
        isEqual(
          test: $0,
          actual: $0.sizeThatFits.width,
          expected: $0.widthRestrictions.min ?? .greatestFiniteMagnitude,
          errorMessage: { "Actual width \($0) != minimum possible width \($1)" }
        )
      }
  }

  func testStretchableWidth3() {
    _ = (1...1000)
      .map { _ in
        let array: [CGFloat] =
          [.randomUiDimension(), .randomUiDimension()].sorted(by: <)

        return Test(
          widthRestrictions: .init(min: nil, max: array[0]),
          mustStretchHorizontally: true,
          sizeToFit: .random(width: array[1])
        )
      }
      .prefix {
        isEqual(
          test: $0,
          actual: $0.sizeThatFits.width,
          expected: $0.widthRestrictions.max ?? 0,
          errorMessage: { "Actual width \($0) != maximum possible width \($1)" }
        )
      }
  }

  func testStretchableWidth4() {
    _ = (1...1000)
      .map { _ in
        let array: [CGFloat] =
          [.randomUiDimension(), .randomUiDimension(), .randomUiDimension()].sorted(by: <)

        return Test(
          widthRestrictions: .init(
            min: Bool.random() ? array[0] : nil,
            max: Bool.random() ? array[2] : nil
          ),
          mustStretchHorizontally: true,
          sizeToFit: .random(width: array[1])
        )
      }
      .prefix {
        isEqual(
          test: $0,
          actual: $0.sizeThatFits.width,
          expected: $0.sizeToFit.width,
          errorMessage: { "Actual width \($0) != sizeToFit's width \($1)" }
        )
      }
  }
}
