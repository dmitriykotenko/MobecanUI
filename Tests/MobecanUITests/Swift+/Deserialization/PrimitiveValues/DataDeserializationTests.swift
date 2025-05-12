// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


final class DataDeserializationTests: DeserializationTester {

  func testValidData1() {
    check(
      deserializedType: Data.self,
      jsonString: """
      ""
      """,
      expectedResult: .success(Data())
    )
  }

  func testValidData2() {
    check(
      deserializedType: Data.self,
      jsonString: """
      "MTIz"
      """,
      expectedResult: .success(
        "123".data(using: .utf8)!
      )
    )
  }

  func testValidData3() {
    check(
      deserializedType: Data.self,
      jsonString: """
      "8J+Nnw=="
      """,
      expectedResult: .success(
        "🍟".data(using: .utf8)!
      )
    )
  }

  func testInvalidData1() {
    check(
      deserializedType: Data.self,
      jsonString: "false",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: String.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode String but found bool instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidData2() {
    check(
      deserializedType: Data.self,
      jsonString: "0",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: String.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode String but found number instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidData3() {
    check(
      deserializedType: Data.self,
      jsonString: "1.1",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: String.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode String but found number instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidData4() {
    check(
      deserializedType: Data.self,
      jsonString: "88888888888888888888888888888888888888888888888888888888888888888888",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: String.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode String but found number instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidData5() {
    check(
      deserializedType: Data.self,
      jsonString: "[]",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: String.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode String but found an array instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidData6() {
    check(
      deserializedType: Data.self,
      jsonString: "{}",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: String.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode String but found a dictionary instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidData7() {
    check(
      deserializedType: Data.self,
      jsonString: """
      "111"
      """,
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [],
          debugDescription: "Encountered Data is not valid Base64.",
          underlyingError: nil
        )
      )
    )
  }

  func testNullData1() {
    check(
      deserializedType: Data?.self,
      jsonString: "null",
      expectedResult: .success(nil)
    )
  }

  func testNullData2() {
    check(
      deserializedType: Data.self,
      jsonString: "null",
      expectedDecodingError: .valueNotFound(
        expectedType: .init(type: Data.self),
        context: .init(
          codingPath: [],
          debugDescription: unexpectedNullErrorMessage(exectedType: Data.self),
          underlyingError: nil
        )
      )
    )
  }

  func testCorruptedJson1() {
    check(
      deserializedType: Data.self,
      jsonString: corruptedJson1,
      expectedDecodingError: errorWhenDecodingCorruptedJson1
    )
  }

  func testCorruptedJson2() {
    check(
      deserializedType: Data.self,
      jsonString: corruptedJson2,
      expectedDecodingError: errorWhenDecodingCorruptedJson2
    )
  }
}
