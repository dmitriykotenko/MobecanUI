import XCTest

import LayoutKit
import RxCocoa
import RxCocoaRuntime
import RxSwift
import RxTest
import SnapKit

@testable import MobecanUI


class LayoutInvalidationPropagatorTests: XCTestCase {

  func testPropagation() {
    let subview = UIView()
    let view = UIView()
    let superview = PropagatorView()

    let superSuperView = UIView()

    superSuperView.addSubview(superview)
    superview.addSubview(view)
    view.addSubview(subview)

    subview.superview?.subviewNeedsToLayout(subview: subview)

    XCTAssertEqual(superview.invalidatedSubview, view)
  }
}


private class PropagatorView: UIView, LayoutInvalidationPropagator {

  var invalidatedSubview: UIView? = nil

  func subviewDidInvalidateLayout(subview: UIView) {
    invalidatedSubview = subview
  }
}
