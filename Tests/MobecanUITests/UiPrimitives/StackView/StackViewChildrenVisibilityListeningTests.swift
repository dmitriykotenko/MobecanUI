import XCTest

import LayoutKit
import RxCocoa
import RxCocoaRuntime
import RxSwift
import RxTest
import SnapKit
import UIKit

@testable import MobecanUI


class StackViewChildrenVisibilityListeningTests: XCTestCase {

  func testListening() {
    let firstChild = UIView.spacer(width: 100, height: 20)
    let secondChild = UIView.spacer(width: 100, height: 50)

    let stackView = UIView.vstack([firstChild, secondChild])

    let stackViewContainer = UIView.vstack([stackView])
    stackViewContainer.frame = .init(x: 0, y: 0, width: 100, height: 800)

    stackViewContainer.layoutIfNeeded()

    XCTAssertEqual(stackView.frame.size, .init(width: 100, height: 70))

    secondChild.isHidden = true

    stackViewContainer.layoutIfNeeded()

    XCTAssertEqual(stackView.frame.height, 20)

    secondChild.isHidden = false
    firstChild.isHidden = true

    stackViewContainer.layoutIfNeeded()

    XCTAssertEqual(stackView.frame.height, 50)
  }
}


private extension UIImageView {

  static func circleImageView(radius: CGFloat) -> SizableImageView {
    let diameter = radius * 2

    return SizableImageView()
      .fixWidth(diameter)
      .fixHeight(diameter)
      .cornerRadius(radius)
      .contentMode(.scaleAspectFill)
      .clipsToBounds(true)
  }
}
