import XCTest

@testable import MobecanUI


final class ArrayFoldingTests: XCTestCase {

  func testEmptyArray() {
    XCTAssertEqual(
      [Int]().foldWhile(-1, { .next($0 + $1 + 500) }),
      -1
    )

    XCTAssertEqual(
      [Int]().foldWhileFromRight(-1, { .next($0 + $1 + 500) }),
      -1
    )
  }

  func testImmediateStop() {
    XCTAssertEqual(
      [Int]().foldWhile(-1, { _, _ in .stop(333) }),
      -1
    )

    XCTAssertEqual(
      [1].foldWhile(-1, { _, _ in .stop(333) }),
      333
    )

    XCTAssertEqual(
      [Int]().foldWhileFromRight(-1, { _, _ in .stop(333) }),
      -1
    )

    XCTAssertEqual(
      [1].foldWhileFromRight(-1, { _, _ in .stop(333) }),
      333
    )
  }

  func testElementsCollection() {
    XCTAssertEqual(
      [2, 56, 8, 7, 4].foldWhile([""], { result, element in
        element % 2 == 0 ?
          .next(result + ["\(element)"]) :
          .stop(result)
      }),
      ["", "2", "56", "8"]
    )

    XCTAssertEqual(
      [2, 56, 8, 7, 4].foldWhileFromRight([""], { element, result in
        element % 2 == 0 ?
          .next(["\(element)"] + result) :
          .stop(result)
      }),
      ["4", ""]
    )
  }

  func testComplexFolding() {
    XCTAssertEqual(
      [2, 56, 8, 7, 4].foldWhile(0, { result, element in
        (result + element) % 3 == 0 ?
          .stop(result * element) :
          .next(result + element)
      }),
      (2 + 56) * 8
    )

    XCTAssertEqual(
      [2, 56, 8, 7, 4].foldWhileFromRight(0, { element, result in
        (element + result) % 3 == 0 ?
          .stop(element * result) :
          .next(element + result)
      }),
      56 * (4 + 7 + 8)
    )
  }
}
