import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


final class ArrayJoiningTests: XCTestCase {
  
  func testJoiningOfEmptyArray() {
    let emptyArray: [Int] = []
    
    XCTAssertEqual(
      emptyArray.joined(start: 1, separator: 2, end: 3),
      [1, 3]
    )
  }
  
  func testJoiningWithEmptySeparator() {
    let array = [1, 2, 3, 4, 5]
    
    XCTAssertEqual(
      array.joined(separator: nil),
      [1, 2, 3, 4, 5]
    )
  }
  
  func testJoiningWithEmptyStart() {
    let array = [1, 2, 3]
    
    XCTAssertEqual(
      array.joined(separator: 0, end: 200),
      [1, 0, 2, 0, 3, 200]
    )
  }
  
  func testJoiningWithEmptyEnd() {
    let array = [1, 2, 3]
    
    XCTAssertEqual(
      array.joined(start: -200, separator: 0),
      [-200, 1, 0, 2, 0, 3]
    )
  }

  func testJoiningWithEmptyStartAndEnd() {
    let array = [1, 2, 3]
    
    XCTAssertEqual(
      array.joined(separator: 0),
      [1, 0, 2, 0, 3]
    )
  }
  
  func testJoiningOfSingleElementArray() {
    XCTAssertEqual(
      [1].joined(start: 0, separator: 100, end: 200),
      [0, 1, 200]
    )
  }
  
  func testJoiningWithLazySeparator() {
    let separators = [-1, -2, -3]
    var iterator = separators.makeIterator()
    
    XCTAssertEqual(
      [1, 2, 3, 4].joined(start: 0, separator: { iterator.next() }, end: 99),
      [0, 1, -1, 2, -2, 3, -3, 4, 99]
    )
  }

  static var allTests = [
    ("Test joining of empty array", testJoiningOfEmptyArray),
    ("Test joining with empty separator", testJoiningWithEmptySeparator),
    ("Test joining with empty start", testJoiningWithEmptyStart),
    ("Test joining with empty end", testJoiningWithEmptyEnd),
    ("Test joining with empty start and empty end", testJoiningWithEmptyStartAndEnd),
    ("Test joinig of single element array", testJoiningOfSingleElementArray),
    ("Test joining with lazy separator", testJoiningWithLazySeparator)
  ]
}
