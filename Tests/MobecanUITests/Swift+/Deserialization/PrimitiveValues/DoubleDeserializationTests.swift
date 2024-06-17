// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


final class DoubleDeserializationTests: DeserializationTester {

  func testValidDouble1() {
    check(
      deserializedType: Double.self,
      jsonString: "9876543210",
      expectedResult: .success(9876543210)
    )
  }

  func testValidDouble2() {
    check(
      deserializedType: Double.self,
      jsonString: "0.0",
      expectedResult: .success(0)
    )
  }

  func testValidDouble3() {
    check(
      deserializedType: Double.self,
      jsonString: "-0.00014",
      expectedResult: .success(-0.00014)
    )
  }

  func testValidDouble4() {
    check(
      deserializedType: Double.self,
      jsonString: "5.4e+91",
      expectedResult: .success(5.4e+91)
    )
  }

  func testInvalidDouble1() {
    check(
      deserializedType: Double.self, 
      jsonString: "false",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Double.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode Double but found bool instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidDouble2() {
    check(
      deserializedType: Double.self,
      jsonString: """
      ""
      """,
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Double.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode Double but found a string instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidDouble3() {
    check(
      deserializedType: Double.self,
      jsonString: "[]",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Double.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode Double but found an array instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidDouble4() {
    check(
      deserializedType: Double.self,
      jsonString: "{}",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Double.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode Double but found a dictionary instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidDouble5() {
    check(
      deserializedType: Double.self,
      jsonString: "-99.99e-99999",
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [],
          debugDescription: "The given data was not valid JSON.",
          underlyingError: 
            NSError(
              domain: "NSCocoaErrorDomain",
              code: 3840,
              userInfo: ["NSDebugDescription": "Number -99.99e-99999 is not representable in Swift."]
            )
            .stableDescription
        )
      )
    )
  }

  func testNullDouble1() {
    check(
      deserializedType: Double?.self,
      jsonString: "null",
      expectedResult: .success(nil)
    )
  }

  func testNullDouble2() {
    check(
      deserializedType: Double.self,
      jsonString: "null",
      expectedDecodingError: .valueNotFound(
        expectedType: .init(type: Double.self),
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
      deserializedType: Double.self,
      jsonString: corruptedJson1,
      expectedDecodingError: errorWhenDecodingCorruptedJson1
    )
  }

  func testCorruptedJson2() {
    check(
      deserializedType: Double.self,
      jsonString: corruptedJson2,
      expectedDecodingError: errorWhenDecodingCorruptedJson2
    )
  }
}
