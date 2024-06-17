// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


final class StringBasedEnumDeserializationTests: DeserializationTester {

  func testValidEnum1() {
    check(
      deserializedType: CityEnum.self,
      jsonString: "\"melbourne\"",
      expectedResult: .success(.melbourne)
    )
  }

  func testValidEnum2() {
    check(
      deserializedType: CityEnum.self,
      jsonString: "\"buenosAires\"",
      expectedResult: .success(.buenosAires)
    )
  }

  func testEmptyString() {
    check(
      deserializedType: CityEnum.self,
      jsonString: """
      ""
      """,
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [],
          debugDescription: "Cannot initialize CityEnum from invalid String value ",
          underlyingError: nil
        )
      )
    )
  }

  func testUnknownEnumCase1() {
    check(
      deserializedType: CityEnum.self,
      jsonString: "\"london\"",
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [],
          debugDescription: "Cannot initialize CityEnum from invalid String value london",
          underlyingError: nil
        )
      )
    )
  }

  func testUnknownEnumCase2() {
    check(
      deserializedType: CityEnum.self,
      jsonString: "\"BuenosAires\"",
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [],
          debugDescription: "Cannot initialize CityEnum from invalid String value BuenosAires",
          underlyingError: nil
        )
      )
    )
  }

  func testTypeMismatch1() {
    check(
      deserializedType: CityEnum.self,
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

  func testTypeMismatch2() {
    check(
      deserializedType: CityEnum.self,
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

  func testTypeMismatch3() {
    check(
      deserializedType: CityEnum.self,
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

  func testTypeMismatch4() {
    check(
      deserializedType: CityEnum.self,
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

  func testNullEnum1() {
    check(
      deserializedType: CityEnum?.self,
      jsonString: "null",
      expectedResult: .success(nil)
    )
  }

  func testNullEnum2() {
    check(
      deserializedType: CityEnum.self,
      jsonString: "null",
      expectedDecodingError: .valueNotFound(
        expectedType: .init(type: String.self),
        context: .init(
          codingPath: [],
          debugDescription: "Cannot get unkeyed decoding container -- found null value instead",
          underlyingError: nil
        )
      )
    )
  }

  func testCorruptedJson1() {
    check(
      deserializedType: CityEnum.self,
      jsonString: corruptedJson1,
      expectedDecodingError: errorWhenDecodingCorruptedJson1
    )
  }

  func testCorruptedJson2() {
    check(
      deserializedType: CityEnum.self,
      jsonString: corruptedJson2,
      expectedDecodingError: errorWhenDecodingCorruptedJson2
    )
  }
}
