import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


final class ArrayFlatJoiningTests: XCTestCase {
  
  func testFlatJoiningOfEmptyArray() {
    let emptyArray: [[Int]] = []
    
    XCTAssertEqual(
      emptyArray.flatJoined(start: 1, separator: 2, end: 3),
      [1, 3]
    )
  }
  
  func testFlatJoiningWithEmptySeparator() {
    let array = [[1, 2], [3], [4, 5]]
    
    XCTAssertEqual(
      array.flatJoined(separator: nil),
      [1, 2, 3, 4, 5]
    )
  }
  
  func testFlatJoiningWithEmptyStart() {
    let array = [[1, 2], [3], [4, 5]]
    
    XCTAssertEqual(
      array.flatJoined(separator: 0, end: 200),
      [1, 2, 0, 3, 0, 4, 5, 200]
    )
  }
  
  func testFlatJoiningWithEmptyEnd() {
    let array = [[1, 2], [3], [4, 5]]
    
    XCTAssertEqual(
      array.flatJoined(start: -200, separator: 0),
      [-200, 1, 2, 0, 3, 0, 4, 5]
    )
  }

  func testFlatJoiningWithEmptyStartAndEnd() {
    let array = [[1, 2], [3], [4, 5]]
    
    XCTAssertEqual(
      array.flatJoined(separator: 0),
      [1, 2, 0, 3, 0, 4, 5]
    )
  }

  func testFlatJoiningOfSingleElementArray() {
    XCTAssertEqual(
      [[1]].flatJoined(start: 0, separator: 100, end: 200),
      [0, 1, 200]
    )
  }
  
  func testFlatJoiningWithLazySeparator() {
    let array = [[1, 2], [3], [4, 5], [6, 7, 8]]
    let separators = [-1, -2, -3]
    var iterator = separators.makeIterator()
    
    XCTAssertEqual(
      array.flatJoined(start: 0, separator: { iterator.next() }, end: 200),
      [0, 1, 2, -1, 3, -2, 4, 5, -3, 6, 7, 8, 200]
    )
  }

  static var allTests = [
    ("Test flat-joining of empty array", testFlatJoiningOfEmptyArray),
    ("Test flat-joining with empty separator", testFlatJoiningWithEmptySeparator),
    ("Test flat-joining with empty start", testFlatJoiningWithEmptyStart),
    ("Test flat-joining with empty end", testFlatJoiningWithEmptyEnd),
    ("Test flat-joining with empty start and empty end", testFlatJoiningWithEmptyStartAndEnd),
    ("Test flat-joinig of single element array", testFlatJoiningOfSingleElementArray),
    ("Test flat-joining with lazy separator", testFlatJoiningWithLazySeparator)
  ]
}
