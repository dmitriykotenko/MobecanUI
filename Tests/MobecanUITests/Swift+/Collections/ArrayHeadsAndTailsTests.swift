import XCTest

@testable import MobecanUI


final class ArrayHeadsAndTailsTests: XCTestCase {

  func testTails() {
    XCTAssertEqual([Int]().tails, [])
    XCTAssertEqual([1].tails, [])
    XCTAssertEqual([1, 2].tails, [[2]])

    XCTAssertEqual(
      [1, 2, 3, 4].tails,
      [[2, 3, 4], [3, 4], [4]]
    )
  }

  func testTailsIncludingSelf() {
    XCTAssertEqual([Int]().tailsIncludingSelf, [])
    XCTAssertEqual([1].tailsIncludingSelf, [[1]])
    XCTAssertEqual([1, 2].tailsIncludingSelf, [[1, 2], [2]])

    XCTAssertEqual(
      [1, 2, 3, 4].tailsIncludingSelf,
      [[1, 2, 3, 4], [2, 3, 4], [3, 4], [4]]
    )
  }

  func testHeads() {
    XCTAssertEqual([Int]().heads, [])
    XCTAssertEqual([1].heads, [])
    XCTAssertEqual([1, 2].heads, [[1]])

    XCTAssertEqual(
      [1, 2, 3, 4].heads,
      [[1], [1, 2], [1, 2, 3]]
    )
  }

  func testHeadsIncludingSelf() {
    XCTAssertEqual([Int]().headsIncludingSelf, [])
    XCTAssertEqual([1].headsIncludingSelf, [[1]])
    XCTAssertEqual([1, 2].headsIncludingSelf, [[1], [1, 2]])

    XCTAssertEqual(
      [1, 2, 3, 4].headsIncludingSelf,
      [[1], [1, 2], [1, 2, 3], [1, 2, 3, 4]]
    )
  }

  func testSingleElementChunks() {
    check(
      array: [1, 2, 3],
      chunkLength: 1,
      expectedChunks: [[1], [2], [3]]
    )
  }

  func testChunksOfEqualLength() {
    check(
      array: [1, 2, 3, 4, 5, 6, 7, 8, 9],
      chunkLength: 3,
      expectedChunks: [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    )
  }

  func testShortenedLastChunk() {
    check(
      array: [1, 2, 3, 4, 5, 6, 7, 8, 9],
      chunkLength: 4,
      expectedChunks: [[1, 2, 3, 4], [5, 6, 7, 8], [9]]
    )
  }

  func testSingleChunk() {
    check(
      array: [1, 2, 3],
      chunkLength: 98,
      expectedChunks: [[1, 2, 3]]
    )
  }

  func testChunksFromRightOfEmptyArray() {
    check(
      array: [],
      chunkLength: 50,
      expectedChunksFromRight: []
    )
  }

  func testSingleElementChunksFromRight() {
    check(
      array: [1, 2, 3],
      chunkLength: 1,
      expectedChunksFromRight: [[1], [2], [3]]
    )
  }

  func testChunksFromRightOfEqualLength() {
    check(
      array: [1, 2, 3, 4, 5, 6, 7, 8, 9],
      chunkLength: 3,
      expectedChunksFromRight: [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    )
  }

  func testShortenedFirstChunkFromRight() {
    check(
      array: [1, 2, 3, 4, 5, 6, 7, 8, 9],
      chunkLength: 4,
      expectedChunksFromRight: [[1], [2, 3, 4, 5], [6, 7, 8, 9]]
    )
  }

  func testSingleChunkFromRight() {
    check(
      array: [1, 2, 3],
      chunkLength: 98,
      expectedChunksFromRight: [[1, 2, 3]]
    )
  }

  private func check(array: [Int],
                     chunkLength: Int,
                     expectedChunks: [[Int]]) {
    XCTAssertEqual(
      array.chunks(length: chunkLength),
      expectedChunks
    )
  }

  private func check(array: [Int],
                     chunkLength: Int,
                     expectedChunksFromRight: [[Int]]) {
    XCTAssertEqual(
      array.chunksFromRight(length: chunkLength),
      expectedChunksFromRight
    )
  }
}
