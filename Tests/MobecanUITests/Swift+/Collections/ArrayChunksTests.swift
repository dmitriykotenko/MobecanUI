import XCTest

@testable import MobecanUI


final class ArrayChunksTests: XCTestCase {

  func testChunksOfEmptyArray() {
    check(
      array: [],
      chunkLength: 50,
      expectedChunks: []
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
