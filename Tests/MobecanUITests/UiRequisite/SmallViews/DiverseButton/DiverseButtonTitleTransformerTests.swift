import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


class DiverseButtonTitleTransformerTests: XCTestCase {

  func testTitleTransformer() {
    let button = DiverseButton()

    button.titleTransformer = { ($0?.reversed()).map { String($0) } }
    button.setTitle("Normal", for: UIControl.State.normal)
    button.setTitle("Highlighted", for: UIControl.State.highlighted)

    XCTAssertEqual(button.title(for: UIControl.State.normal), "lamroN")
    XCTAssertEqual(button.title(for: UIControl.State.highlighted), "dethgilhgiH")
  }

  static var allTests = [
    ("Test title transformer", testTitleTransformer),
  ]
}
