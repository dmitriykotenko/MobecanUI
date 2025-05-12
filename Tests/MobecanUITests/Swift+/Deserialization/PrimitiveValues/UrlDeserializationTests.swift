// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


final class UrlDeserializationTests: DeserializationTester {

  func testEmptyUrl() {
    check(
      deserializedType: URL.self,
      jsonString: """
      "https://"
      """,
      expectedResult: .success(URL(string: "https://")!)
    )
  }

  func testValidUrl1() {
    check(
      deserializedType: URL.self,
      jsonString: """
      "https://www.yandex.ru"
      """,
      expectedResult: .success(URL(string: "https://www.yandex.ru")!)
    )
  }

  func testValidUrl2() {
    check(
      deserializedType: URL.self,
      jsonString: """
      "0.0.0.0"
      """,
      expectedResult: .success(URL(string: "0.0.0.0")!)
    )
  }

  func testValidUrl3() {
    check(
      deserializedType: URL.self,
      jsonString: """
      "https://www.bftcom.com/someValidUrl?shouldBeParsed=true&contentLength=72"
      """,
      expectedResult: 
        .success(URL(string: "https://www.bftcom.com/someValidUrl?shouldBeParsed=true&contentLength=72")!)
    )
  }

  func testValidUrl4() {
    check(
      deserializedType: URL.self,
      jsonString: """
      "https://бфтком.рф"
      """,
      expectedResult: .success(URL(string: "https://бфтком.рф")!)
    )
  }

  func testInvalidUrl1() {
    check(
      deserializedType: URL.self,
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

  func testInvalidUrl2() {
    check(
      deserializedType: URL.self,
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

  func testInvalidUrl3() {
    check(
      deserializedType: URL.self,
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

  func testInvalidUrl4() {
    check(
      deserializedType: URL.self,
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

  func testInvalidUrl5() {
    check(
      deserializedType: URL.self,
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

  func testInvalidUrl6() {
    check(
      deserializedType: URL.self,
      jsonString: """
      ""
      """,
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [],
          debugDescription: "Invalid URL string.",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidUrl7() {
    check(
      deserializedType: URL.self,
      jsonString: """
      "Welcome to hell :-)"
      """,
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [],
          debugDescription: "Invalid URL string.",
          underlyingError: nil
        )
      )
    )
  }

  func testNullUrl1() {
    check(
      deserializedType: URL?.self,
      jsonString: "null",
      expectedResult: .success(nil)
    )
  }

  func testNullUrl2() {
    check(
      deserializedType: URL.self,
      jsonString: "null",
      expectedDecodingError: .valueNotFound(
        expectedType: .init(type: URL.self),
        context: .init(
          codingPath: [],
          debugDescription: unexpectedNullErrorMessage(exectedType: URL.self),
          underlyingError: nil
        )
      )
    )
  }

  func testCorruptedJson1() {
    check(
      deserializedType: URL.self,
      jsonString: corruptedJson1,
      expectedDecodingError: errorWhenDecodingCorruptedJson1
    )
  }

  func testCorruptedJson2() {
    check(
      deserializedType: URL.self,
      jsonString: corruptedJson2,
      expectedDecodingError: errorWhenDecodingCorruptedJson2
    )
  }
}
