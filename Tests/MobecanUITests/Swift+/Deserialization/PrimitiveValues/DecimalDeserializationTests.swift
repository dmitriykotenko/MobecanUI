// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


final class DecimalDeserializationTests: DeserializationTester {

  func testValidDecimal1() {
    check(
      deserializedType: Decimal.self,
      jsonString: "9876543210",
      expectedResult: .success(9876543210)
    )
  }

  func testValidDecimal2() {
    check(
      deserializedType: Decimal.self,
      jsonString: "0.0",
      expectedResult: .success(0)
    )
  }

  func testValidDecimal3() {
    check(
      deserializedType: Decimal.self,
      jsonString: "2.1",
      expectedResult: .success(2.1)
    )
  }

  func testValidDecimal4() {
    check(
      deserializedType: Decimal.self,
      jsonString: "-0.00014",
      expectedResult: .success(-0.00014)
    )
  }

  func testValidDecimal5() {
    check(
      deserializedType: Decimal.self,
      jsonString: "5.4e+91",
      expectedResult: .success(Decimal(string: "5.4e+91")!)
    )
  }

  func testValidDecimal6() {
    check(
      deserializedType: Decimal.self,
      jsonString: "-99.99e-123",
      expectedResult: .success(Decimal(string: "-99.99e-123")!)
    )
  }

  func testValidDecimal7() {
    check(
      deserializedType: Decimal.self,
      jsonString: "99.99e+123",
      expectedResult: .success(Decimal(string: "99.99e+123")!)
    )
  }

  func testInvalidDecimal1() {
    check(
      deserializedType: Decimal.self, 
      jsonString: "false",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Decimal.self),
        context: .init(
          codingPath: [],
          debugDescription: "",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidDecimal2() {
    check(
      deserializedType: Decimal.self,
      jsonString: """
      ""
      """,
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Decimal.self),
        context: .init(
          codingPath: [],
          debugDescription: "",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidDecimal3() {
    check(
      deserializedType: Decimal.self,
      jsonString: "[]",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Decimal.self),
        context: .init(
          codingPath: [],
          debugDescription: "",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidDecimal4() {
    check(
      deserializedType: Decimal.self,
      jsonString: "{}",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Decimal.self),
        context: .init(
          codingPath: [],
          debugDescription: "",
          underlyingError: nil
        )
      )
    )
  }

  func testNullDecimal1() {
    check(
      deserializedType: Decimal?.self,
      jsonString: "null",
      expectedResult: .success(nil)
    )
  }

  func testNullDecimal2() {
    check(
      deserializedType: Decimal.self,
      jsonString: "null",
      expectedDecodingError: .valueNotFound(
        expectedType: .init(type: Decimal.self),
        context: .init(
          codingPath: [],
          debugDescription: unexpectedNullErrorMessage(exectedType: Decimal.self),
          underlyingError: nil
        )
      )
    )
  }

  func testCorruptedJson1() {
    check(
      deserializedType: Decimal.self,
      jsonString: corruptedJson1,
      expectedDecodingError: errorWhenDecodingCorruptedJson1
    )
  }

  func testCorruptedJson2() {
    check(
      deserializedType: Decimal.self,
      jsonString: corruptedJson2,
      expectedDecodingError: errorWhenDecodingCorruptedJson2
    )
  }
}
