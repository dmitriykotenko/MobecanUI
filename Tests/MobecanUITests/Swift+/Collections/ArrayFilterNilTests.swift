import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


final class ArrayFilterNilTests: XCTestCase {
  
  func testFilterNil() {
    XCTAssertEqual(
      [nil, 1, 2, 3, nil, 4, nil, nil, nil].filterNil(),
      [1, 2, 3, 4]
    )
  }

  func testFilterNilKeepOptional() {
    XCTAssertEqual(
      [nil, 9, 2, nil, 6, nil, 0, nil, nil, nil].filterNilKeepOptional(),
      [9, 2, 6, 0]
    )
  }

  static var allTests = [
    ("Test filterNil", testFilterNil),
    ("Test filterNilKeepOptional", testFilterNilKeepOptional)
  ]
}
