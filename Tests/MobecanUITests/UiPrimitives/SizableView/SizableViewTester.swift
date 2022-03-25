import XCTest

import LayoutKit
import RxCocoa
import RxCocoaRuntime
import RxSwift
import RxTest
import SnapKit
import UIKit

@testable import MobecanUI


class SizableViewTester: XCTestCase {

  let maximumPossibleSize = CGSize(
    width: CGFloat.greatestFiniteMagnitude,
    height: CGFloat.greatestFiniteMagnitude
  )

  func isEqual(test: Test,
               actual: CGFloat,
               expected: CGFloat,
               errorMessage: (CGFloat, CGFloat) -> String) -> Bool {
    if actual == expected {
      return true
    } else {
      let message = errorMessage(actual, expected)
      XCTFail("""
        \(test)

        \(message)
        """
      )
      return false
    }
  }

  func isGreater(test: Test,
                 actual: CGFloat,
                 expected: CGFloat,
                 errorMessage: (CGFloat, CGFloat) -> String) -> Bool {
    if actual >= expected {
      return true
    } else {
      let message = errorMessage(actual, expected)
      XCTFail("""
        \(test)

        \(message)
        """
      )
      return false
    }
  }

  func isLess(test: Test,
              actual: CGFloat,
              expected: CGFloat,
              errorMessage: (CGFloat, CGFloat) -> String) -> Bool {
    if actual <= expected {
      return true
    } else {
      let message = errorMessage(actual, expected)
      XCTFail("""
        \(test)

        \(message)
        """
      )
      return false
    }
  }

  struct Test: CustomStringConvertible {

    var nativeWidth: CGFloat = .randomUiDimension()
    var nativeHeight: CGFloat = .randomUiDimension()

    var widthRestrictions: OptionalRange = .random()
    var heightRestrictions: OptionalRange = .random()

    var mustStretchHorizontally: Bool = .random()
    var mustStretchVertically: Bool = .random()

    var sizeToFit: CGSize = .random()

    var view: UIView {
      let result = ExampleOfSizableView(
        frame: .init(x: 0, y: 0, width: nativeWidth, height: nativeHeight)
      )

      result
        .fixMinimumWidth(widthRestrictions.min)
        .fixMinimumHeight(heightRestrictions.min)
        .fixMaximumWidth(widthRestrictions.max)
        .fixMaximumHeight(heightRestrictions.max)

      if mustStretchHorizontally { result.withStretchableWidth() }
      if mustStretchVertically { result.withStretchableHeight() }

      return result
    }

    var nativeSize: CGSize {
      .init(
        width: nativeWidth,
        height: nativeHeight
      )
    }

    var sizeThatFits: CGSize {
      view.sizeThatFits(sizeToFit)
    }

    var description: String {
      """
      Test:
        Native size: \(nativeSize)
        Width limit: \(widthRestrictions)
        Height limit: \(heightRestrictions)
        Must stretch horizontally: \(mustStretchHorizontally)
        Must stretch vertically: \(mustStretchVertically)
        Size to fit: \(sizeToFit)
        Size that fits: \(sizeThatFits)
      """
    }
  }
}


private class ExampleOfSizableView: UIView, SizableView {

  open var sizer = ViewSizer()

  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    sizer.sizeThatFits(
      size,
      nativeSizing: super.sizeThatFits
    )
  }
}


extension CGFloat {

  static func randomUiDimension(from: CGFloat? = nil,
                                to: CGFloat? = nil) -> CGFloat {
    CGFloat(
      Int(
        CGFloat.random(in: (from ?? 0)...(to ?? 10_000))
      )
    )
  }

  static func randomOptionalUiDimension(from: CGFloat? = nil,
                                        to: CGFloat? = nil) -> CGFloat? {
    Bool.random() ? nil : randomUiDimension(from: from, to: to)
  }
}


struct OptionalRange: CustomStringConvertible {

  var min: CGFloat?
  var max: CGFloat?

  var description: String {
    let minString = min.map { "\($0) "} ?? "nil"
    let maxString = max.map { "\($0) "} ?? "nil"

    return "\(minString)...\(maxString)"
  }

  static func random() -> OptionalRange {
    let first = Bool.random() ? nil : CGFloat.randomUiDimension()

    let second =
      Bool.random() ? nil :
      Bool.random() ? first :
      CGFloat.randomUiDimension()

    return zip(first, second)
      .map { .init(min: Swift.min($0, $1), max: Swift.max($0, $1)) }
      ?? .init(min: first, max: second)
  }

  static func random(min: CGFloat?) -> OptionalRange {
    .init(
      min: min,
      max: Bool.random() ? nil : Bool.random() ? min : .randomUiDimension(from: min)
    )
  }

  static func random(max: CGFloat?) -> OptionalRange {
    .init(
      min: Bool.random() ? nil : Bool.random() ? max : .randomUiDimension(to: max),
      max: max
    )
  }
}


extension CGSize {

  static func random(width: CGFloat? = nil,
                     height: CGFloat? = nil) -> CGSize {
    .init(
      width: width ?? .randomUiDimension(),
      height: height ?? .randomUiDimension()
    )
  }
}
