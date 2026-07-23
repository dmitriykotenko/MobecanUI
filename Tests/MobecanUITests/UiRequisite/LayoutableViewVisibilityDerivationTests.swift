import XCTest

import UIKit

@testable import MobecanUI


final class LayoutableViewVisibilityDerivationTests: XCTestCase {

  func testInitialDerivedVisibilityFromSingleView() {
    let sourceView = UIView().isHidden(true)

    let derivedView = LayoutableView()
      .withVisibility(derivedFrom: sourceView)

    XCTAssertEqual(derivedView.isVisible, false)
  }

  func testSingleViewBasedVisibilityDerivation() {
    let sourceView = UIView()

    let derivedView = LayoutableView()
      .withVisibility(derivedFrom: sourceView)

    XCTAssertEqual(derivedView.isVisible, true)

    sourceView.isHidden = true

    XCTAssertEqual(derivedView.isVisible, false)

    sourceView.isHidden = false

    XCTAssertEqual(derivedView.isVisible, true)
  }

  func testMultipleViewsBasedVisibilityDerivation() {
    let firstSourceView = UIView().isHidden(true)
    let secondSourceView = UIView().isHidden(true)

    let derivedView = LayoutableView()
      .withVisibility(derivedFromViews: [firstSourceView, secondSourceView]) {
        $0.contains(where: \.isVisible)
      }

    XCTAssertEqual(derivedView.isVisible, false)

    secondSourceView.isHidden = false

    XCTAssertEqual(derivedView.isVisible, true)

    secondSourceView.isHidden = true

    XCTAssertEqual(derivedView.isVisible, false)
  }

  func testStoppingOfVisibilityDerivation() {
    let sourceView = UIView()

    let derivedView = LayoutableView()
      .withVisibility(derivedFrom: sourceView)
      .withoutDerivedVisibility()

    sourceView.isHidden = true

    XCTAssertEqual(derivedView.isVisible, true)
  }

  func testRepeatedSetupOfVisibilityDerivation() {
    let firstSourceView = UIView()
    let secondSourceView = UIView()

    let derivedView = LayoutableView()
      .withVisibility(derivedFrom: firstSourceView)
      .withVisibility(derivedFrom: secondSourceView)

    firstSourceView.isHidden = true

    XCTAssertEqual(derivedView.isVisible, true)

    secondSourceView.isHidden = true

    XCTAssertEqual(derivedView.isVisible, false)
  }
}
